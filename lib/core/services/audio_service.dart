import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:path_provider/path_provider.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  ref.onDispose(() => service.dispose());
  return service;
});

/// Handles notification sounds and text-to-speech for the run session.
///
/// The notification sound is a short two-tone chime generated programmatically
/// as a WAV file — no bundled assets needed. TTS uses the platform's built-in
/// speech engine (SAPI on Windows, Android TTS on Android).
class AudioService {
  final AudioPlayer _player = AudioPlayer();
  final FlutterTts _tts = FlutterTts();
  String? _soundFilePath;
  bool _initialized = false;

  /// Lazily initializes the sound file and TTS engine.
  Future<void> _ensureInitialized() async {
    if (_initialized) return;
    _initialized = true;

    try {
      // Generate and cache the notification sound as a temp file
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/recur_chime.wav');
      if (!await file.exists()) {
        final wavData = _generateChimeWav();
        await file.writeAsBytes(wavData);
      }
      _soundFilePath = file.path;
    } catch (_) {
      // Sound generation failed — we'll just skip playing sounds
    }

    try {
      await _tts.setLanguage('en-US');
      await _tts.setSpeechRate(0.45);
      await _tts.setVolume(1.0);
    } catch (_) {
      // TTS init failed — we'll skip speaking
    }
  }

  /// Plays a short chime sound to indicate a task timer has expired.
  Future<void> playTimerExpiredSound() async {
    await _ensureInitialized();
    final path = _soundFilePath;
    if (path == null) return;

    try {
      await _player.play(DeviceFileSource(path));
    } catch (_) {
      // Playback failed — not critical
    }
  }

  /// Speaks a task prompt like "Get Brush teeth done in 2 minutes".
  Future<void> speakTaskPrompt(String taskName, int durationSeconds) async {
    await _ensureInitialized();
    final duration = _formatDurationForSpeech(durationSeconds);
    try {
      await _tts.speak('Get $taskName done in $duration');
    } catch (_) {
      // TTS failed — not critical
    }
  }

  /// Announces that all tasks are complete.
  Future<void> speakComplete() async {
    await _ensureInitialized();
    try {
      await _tts.speak('All tasks complete. Well done!');
    } catch (_) {
      // TTS failed — not critical
    }
  }

  /// Formats seconds into natural speech like "2 minutes and 30 seconds".
  String _formatDurationForSpeech(int totalSeconds) {
    if (totalSeconds <= 0) return 'your own time';
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    if (minutes == 0) {
      return '$seconds ${seconds == 1 ? "second" : "seconds"}';
    }
    if (seconds == 0) {
      return '$minutes ${minutes == 1 ? "minute" : "minutes"}';
    }
    return '$minutes ${minutes == 1 ? "minute" : "minutes"} '
        'and $seconds seconds';
  }

  /// Generates a pleasant two-tone ascending chime as a WAV byte array.
  ///
  /// The chime consists of two short sine-wave tones (C6 → E6) with
  /// fade-in/fade-out envelopes, sounding like a gentle notification bell.
  Uint8List _generateChimeWav() {
    const sampleRate = 44100;
    const tone1Freq = 1047; // C6
    const tone2Freq = 1319; // E6
    const toneDuration = 0.15; // seconds per tone
    const gap = 0.05; // silence between tones

    final tone1Samples = (sampleRate * toneDuration).toInt();
    final gapSamples = (sampleRate * gap).toInt();
    final tone2Samples = (sampleRate * toneDuration).toInt();
    final totalSamples = tone1Samples + gapSamples + tone2Samples;
    final dataSize = totalSamples * 2; // 16-bit mono
    final fileSize = 44 + dataSize;

    final buffer = ByteData(fileSize);

    // WAV header
    void writeString(int offset, String s) {
      for (int i = 0; i < s.length; i++) {
        buffer.setUint8(offset + i, s.codeUnitAt(i));
      }
    }

    writeString(0, 'RIFF');
    buffer.setUint32(4, fileSize - 8, Endian.little);
    writeString(8, 'WAVE');
    writeString(12, 'fmt ');
    buffer.setUint32(16, 16, Endian.little); // sub-chunk size
    buffer.setUint16(20, 1, Endian.little); // PCM
    buffer.setUint16(22, 1, Endian.little); // mono
    buffer.setUint32(24, sampleRate, Endian.little);
    buffer.setUint32(28, sampleRate * 2, Endian.little); // byte rate
    buffer.setUint16(32, 2, Endian.little); // block align
    buffer.setUint16(34, 16, Endian.little); // bits per sample
    writeString(36, 'data');
    buffer.setUint32(40, dataSize, Endian.little);

    int sampleIndex = 0;

    // Helper: write a tone with fade envelope
    void writeTone(int frequency, int numSamples) {
      for (int i = 0; i < numSamples; i++) {
        final t = i / sampleRate;
        // Smooth fade-in (first 10%) and fade-out (last 30%)
        double envelope = 1.0;
        final fadeIn = numSamples * 0.1;
        final fadeOut = numSamples * 0.3;
        if (i < fadeIn) {
          envelope = i / fadeIn;
        } else if (i > numSamples - fadeOut) {
          envelope = (numSamples - i) / fadeOut;
        }
        final sample =
            (sin(2 * pi * frequency * t) * 32767 * envelope * 0.4).toInt();
        buffer.setInt16(
            44 + sampleIndex * 2, sample.clamp(-32768, 32767), Endian.little);
        sampleIndex++;
      }
    }

    // Tone 1 (C6)
    writeTone(tone1Freq, tone1Samples);

    // Gap (silence)
    for (int i = 0; i < gapSamples; i++) {
      buffer.setInt16(44 + sampleIndex * 2, 0, Endian.little);
      sampleIndex++;
    }

    // Tone 2 (E6)
    writeTone(tone2Freq, tone2Samples);

    return buffer.buffer.asUint8List();
  }

  void dispose() {
    _player.dispose();
    _tts.stop();
  }
}
