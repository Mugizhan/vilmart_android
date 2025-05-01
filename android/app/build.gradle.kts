plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Firebase Google services plugin
}

android {
    namespace = "com.example.vilmart_android"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    // Use Java 17 as required by Firebase and Android Gradle plugin
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17 // Updated to Java 17
        targetCompatibility = JavaVersion.VERSION_17 // Updated to Java 17
    }

    kotlinOptions {
        jvmTarget = "17" // Updated to Java 17
    }

    defaultConfig {
        // Specify your own unique Application ID
        applicationId = "com.example.vilmart_android"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // For now, use debug signing config
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    // Firebase BoM (Bill of Materials) to manage versions
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))

    // Firebase Authentication SDK
    implementation("com.google.firebase:firebase-auth")

    // Add any other Firebase services you want to use, e.g., Firestore
    // implementation("com.google.firebase:firebase-firestore")
}

// Apply the Firebase services plugin
apply(plugin = "com.google.gms.google-services")
