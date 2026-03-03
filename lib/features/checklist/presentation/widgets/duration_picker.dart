import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A custom widget for picking a duration in minutes and seconds.
class DurationPicker extends StatefulWidget {
  final int initialSeconds;
  final ValueChanged<int> onChanged;

  const DurationPicker({
    super.key,
    required this.initialSeconds,
    required this.onChanged,
  });

  @override
  State<DurationPicker> createState() => _DurationPickerState();
}

class _DurationPickerState extends State<DurationPicker> {
  late TextEditingController _minutesController;
  late TextEditingController _secondsController;

  @override
  void initState() {
    super.initState();
    final minutes = widget.initialSeconds ~/ 60;
    final seconds = widget.initialSeconds % 60;
    _minutesController = TextEditingController(text: minutes.toString());
    _secondsController = TextEditingController(text: seconds.toString());
  }

  @override
  void dispose() {
    _minutesController.dispose();
    _secondsController.dispose();
    super.dispose();
  }

  void _onChanged() {
    final minutes = int.tryParse(_minutesController.text) ?? 0;
    final seconds = int.tryParse(_secondsController.text) ?? 0;
    widget.onChanged(minutes * 60 + seconds);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _minutesController,
            decoration: const InputDecoration(
              labelText: 'Minutes',
              suffixText: 'min',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (_) => _onChanged(),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(':', style: TextStyle(fontSize: 24)),
        ),
        Expanded(
          child: TextField(
            controller: _secondsController,
            decoration: const InputDecoration(
              labelText: 'Seconds',
              suffixText: 'sec',
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _MaxValueFormatter(59),
            ],
            onChanged: (_) => _onChanged(),
          ),
        ),
      ],
    );
  }
}

/// Formatter that prevents values above a maximum.
class _MaxValueFormatter extends TextInputFormatter {
  final int max;
  _MaxValueFormatter(this.max);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) return newValue;
    final value = int.tryParse(newValue.text);
    if (value == null || value > max) return oldValue;
    return newValue;
  }
}
