allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    afterEvaluate {
        val lib = extensions.findByType(com.android.build.gradle.LibraryExtension::class.java) ?: return@afterEvaluate
        if (lib.namespace != null) return@afterEvaluate
        val manifest = File(projectDir, "src/main/AndroidManifest.xml")
        if (!manifest.exists()) return@afterEvaluate
        val match = Regex("""package="([^"]+)"""").find(manifest.readText()) ?: return@afterEvaluate
        lib.namespace = match.groupValues[1]
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
