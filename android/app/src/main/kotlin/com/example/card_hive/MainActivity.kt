package com.example.card_hive

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingResult: MethodChannel.Result? = null
    private var currentPermission: String? = null
    private val REQ_CODE = 12345
    private val PERM_CHANNEL = "card_hive/app_settings" // keep same CHANNEL

    private fun checkPermissionStatus(perm: String): String {
        return when (ContextCompat.checkSelfPermission(this, perm)) {
            PackageManager.PERMISSION_GRANTED -> "granted"
            PackageManager.PERMISSION_DENIED -> "denied"
            else -> "denied"
        }
    }

    override fun onRequestPermissionsResult(
            requestCode: Int,
            permissions: Array<String>,
            grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQ_CODE && pendingResult != null) {
            val granted =
                    if (grantResults.isNotEmpty() &&
                                    grantResults[0] == PackageManager.PERMISSION_GRANTED
                    ) {
                        "granted"
                    } else {
                        val perm = permissions.getOrNull(0) ?: ""
                        if (!ActivityCompat.shouldShowRequestPermissionRationale(this, perm))
                                "permanentlyDenied"
                        else "denied"
                    }
            pendingResult?.success(granted)
            pendingResult = null
            currentPermission = null
        }
    }

    override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PERM_CHANNEL).setMethodCallHandler {
                call,
                result ->
            when (call.method) {
                "openAppSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                        val uri: Uri =
                                Uri.fromParts("package", applicationContext.packageName, null)
                        intent.data = uri
                        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                        applicationContext.startActivity(intent)
                        result.success(null)
                    } catch (e: Exception) {
                        result.error("ERROR", "Could not open settings", null)
                    }
                }
                "checkPermission" -> {
                    val perm = call.argument<String>("permission") ?: ""
                    result.success(checkPermissionStatus(perm))
                }
                "requestPermission" -> {
                    val perm = call.argument<String>("permission") ?: ""
                    if (ContextCompat.checkSelfPermission(this, perm) ==
                                    PackageManager.PERMISSION_GRANTED
                    ) {
                        result.success("granted")
                    } else {
                        pendingResult = result
                        currentPermission = perm
                        ActivityCompat.requestPermissions(this, arrayOf(perm), REQ_CODE)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
