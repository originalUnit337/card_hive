package com.example.card_hive

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.provider.Settings

class MainActivity : FlutterActivity() {
  private val CHANNEL = "card_hive/app_settings"

  override fun configureFlutterEngine(flutterEngine: io.flutter.embedding.engine.FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
      if (call.method == "openAppSettings") {
        try {
          val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
          val uri: Uri = Uri.fromParts("package", applicationContext.packageName, null)
          intent.data = uri
          intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
          applicationContext.startActivity(intent)
          result.success(null)
        } catch (e: Exception) {
          result.error("ERROR", "Could not open settings", null)
        }
      } else {
        result.notImplemented()
      }
    }
  }
}
