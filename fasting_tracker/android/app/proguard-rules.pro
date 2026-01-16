# === OTIMIZAÇÃO MÁXIMA ===
-optimizationpasses 7
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
-allowaccessmodification
-repackageclasses ''
-overloadaggressively

# === REMOVER LOGS EM PRODUÇÃO ===
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int d(...);
    public static int i(...);
    public static int w(...);
}

# === KOTLIN OPTIMIZATIONS ===
-assumenosideeffects class kotlin.jvm.internal.Intrinsics {
    public static void checkNotNull(...);
    public static void checkExpressionValueIsNotNull(...);
    public static void checkNotNullExpressionValue(...);
    public static void checkParameterIsNotNull(...);
    public static void checkNotNullParameter(...);
    public static void checkReturnedValueIsNotNull(...);
    public static void checkFieldIsNotNull(...);
    public static void throwUninitializedPropertyAccessException(...);
}

# === FLUTTER ===
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings

# === GOOGLE MOBILE ADS ===
-keep class com.google.android.gms.ads.** { *; }
-keep class com.google.ads.** { *; }

# === UMP (Consent) ===
-keep class com.google.android.ump.** { *; }

# === SHARED PREFERENCES ===
-keep class androidx.datastore.** { *; }

# === FLUTTER LOCAL NOTIFICATIONS ===
-keep class com.dexterous.** { *; }
