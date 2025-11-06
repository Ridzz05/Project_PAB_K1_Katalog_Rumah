# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.

# Flutter wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep image picker
-keep class com.baseflow.permissionhandler.** { *; }
-keep class androidx.camera.** { *; }

# Keep shared preferences
-keep class androidx.preference.** { *; }

# Keep connectivity
-keep class dev.fluttercommunity.plus.connectivity.** { *; }

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

