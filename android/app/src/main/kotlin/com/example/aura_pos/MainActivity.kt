package com.example.aura_pos

import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.aura_pos/installer"
    private var pendingInstallPath: String? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "canInstallPackages" -> result.success(canInstallPackages())
                    "requestInstallPermission" -> {
                        requestInstallPermission()
                        result.success(true)
                    }
                    "installApk" -> {
                        val filePath = call.argument<String>("filePath")
                        if (filePath != null) {
                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !canInstallPackages()) {
                                pendingInstallPath = filePath
                                requestInstallPermission()
                                result.success(false)
                            } else {
                                try {
                                    installApk(filePath)
                                    result.success(true)
                                } catch (e: Exception) {
                                    result.error("INSTALL_FAILED", e.message, null)
                                }
                            }
                        } else {
                            result.error("INVALID_ARGS", "filePath is null", null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        if (pendingInstallPath != null && canInstallPackages()) {
            val path = pendingInstallPath!!
            pendingInstallPath = null
            try {
                installApk(path)
            } catch (_: Exception) {}
        }
    }

    private fun canInstallPackages(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            packageManager.canRequestPackageInstalls()
        } else {
            true
        }
    }

    private fun requestInstallPermission() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES).apply {
                data = Uri.parse("package:$packageName")
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            startActivity(intent)
        }
    }

    private fun installApk(filePath: String) {
        val file = File(filePath)
        if (!file.exists()) {
            throw Exception("APK file not found: $filePath")
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O && !canInstallPackages()) {
            throw Exception("Permiso de instalación no concedido")
        }

        val uri: Uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.N) {
            FileProvider.getUriForFile(this, "${packageName}.fileProvider", file)
        } else {
            Uri.fromFile(file)
        }

        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }

        startActivity(intent)
    }
}
