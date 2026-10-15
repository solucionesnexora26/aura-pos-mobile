# ML Kit instantiates its ComponentRegistrar implementations reflectively by
# class name (androidx ComponentDiscovery / Firebase ComponentRuntime). R8 must
# keep those classes and their no-arg constructors: if <init>() is stripped,
# component discovery fails, BarcodeScanning.getClient() throws a
# NullPointerException and the barcode/QR scanner never starts.
-keep class com.google.mlkit.** { *; }
-keep class com.google.android.gms.internal.mlkit_vision_barcode_bundled.** { *; }

# Rules shipped upstream with mobile_scanner.
-keep class com.google.android.libraries.barhopper.** { *; }
-keep class com.google.photos.* { *; }

-dontwarn com.google.mlkit.**
-dontwarn com.google.android.gms.internal.mlkit_vision_barcode_bundled.**

-keepclassmembers class * extends java.lang.Enum {
    <fields>;
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
