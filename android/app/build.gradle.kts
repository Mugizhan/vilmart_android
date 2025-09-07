plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")  // Apply plugin here without version
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.mib"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.mib"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.14.0"))

    // Add your Firebase dependencies here without versions
    // e.g., implementation("com.google.firebase:firebase-analytics-ktx")
}

flutter {
    source = "../.."
}
