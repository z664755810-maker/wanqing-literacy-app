pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    // v1.16 修复：本机 dl.google.com 的 TLS 握手被代理中断，
    // 改用阿里云镜像（已测试 200 OK）以绕过网络拦截。
    repositories {
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/central") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    // v1.16 修复：Flutter 3.47.1 要求 AGP ≥ 9.0.1 + Kotlin ≥ 2.2.20；
    // gradle.properties 里的 android.newDsl=false / android.builtInKotlin=false 让 Flutter 走旧 DSL，
    // 绕开 FlutterPluginUtils.kt:514 在 AGP 9.x 上的 NPE。
    id("com.android.application") version "9.0.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
