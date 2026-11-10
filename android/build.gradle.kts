allprojects {
    repositories {
        google()
        mavenCentral()
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

// Plugins such as sqflite_android pin their own Android Gradle Plugin in their
// buildscript. At runtime Gradle uses the app's AGP (settings.gradle.kts) anyway,
// so resolve theirs to the same version instead of downloading an unused copy
// (Google Maven is not reachable from every network).
subprojects {
    buildscript.configurations.named("classpath") {
        resolutionStrategy.eachDependency {
            if (requested.group == "com.android.tools.build" && requested.name == "gradle") {
                useVersion(com.android.Version.ANDROID_GRADLE_PLUGIN_VERSION)
                because("use the app's Android Gradle Plugin for every plugin")
            }
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
