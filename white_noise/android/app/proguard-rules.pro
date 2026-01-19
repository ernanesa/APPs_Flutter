# Flutter optimization
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# Google Mobile Ads
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# UMP (Consent)
-keep class com.google.android.ump.** { *; }

# Audioplayers
-keep class xyz.luan.audioplayers.** { *; }

# Remove logs in production
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
    public static int e(...);
}

# Optimization
-optimizationpasses 7
-allowaccessmodification
-repackageclasses 'a'
