package com.cardsaathi.app

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.os.PowerManager
import android.provider.ContactsContract
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val contactChannelName = "com.cardsaathi/contact_picker"
    private val batteryChannelName = "com.cardsaathi/battery_optimization"
    private val requestCodePickContact = 2026
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Contact Picker Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, contactChannelName).setMethodCallHandler { call, result ->
            if (call.method == "pickContact") {
                if (pendingResult != null) {
                    result.error("ALREADY_ACTIVE", "A contact picking session is already in progress.", null)
                    return@setMethodCallHandler
                }
                pendingResult = result
                try {
                    val intent = Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI)
                    startActivityForResult(intent, requestCodePickContact)
                } catch (e: Exception) {
                    pendingResult = null
                    result.error("INTENT_ERROR", e.localizedMessage, null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Google Play 2026 Compliant Battery Optimization & Exact Alarms Channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, batteryChannelName).setMethodCallHandler { call, result ->
            when (call.method) {
                "isIgnoringBatteryOptimizations" -> {
                    try {
                        val powerManager = getSystemService(Context.POWER_SERVICE) as? PowerManager
                        val isIgnoring = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && powerManager != null) {
                            powerManager.isIgnoringBatteryOptimizations(packageName)
                        } else {
                            true
                        }
                        result.success(isIgnoring)
                    } catch (e: Exception) {
                        result.success(true)
                    }
                }
                "openBatteryOptimizationSettings" -> {
                    try {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            val intent = Intent(Settings.ACTION_IGNORE_BATTERY_OPTIMIZATION_SETTINGS)
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } else {
                            result.success(false)
                        }
                    } catch (e: Exception) {
                        try {
                            // Fallback to application details settings
                            val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                            intent.data = Uri.parse("package:$packageName")
                            intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                            startActivity(intent)
                            result.success(true)
                        } catch (ex: Exception) {
                            result.error("SETTINGS_ERROR", ex.localizedMessage, null)
                        }
                    }
                }
                "getManufacturer" -> {
                    result.success(Build.MANUFACTURER ?: "Generic")
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode == requestCodePickContact) {
            val result = pendingResult ?: return
            pendingResult = null

            if (resultCode != Activity.RESULT_OK || data?.data == null) {
                result.success(null)
                return
            }

            val contactUri: Uri = data.data!!
            var name: String? = null
            var phone: String? = null
            var contactId: String? = null

            val projection = arrayOf(
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.CONTACT_ID
            )

            try {
                contentResolver.query(contactUri, projection, null, null, null)?.use { cursor ->
                    if (cursor.moveToFirst()) {
                        val nameIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME)
                        val numberIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER)
                        val idIndex = cursor.getColumnIndex(ContactsContract.CommonDataKinds.Phone.CONTACT_ID)

                        if (nameIndex != -1) name = cursor.getString(nameIndex)
                        if (numberIndex != -1) phone = cursor.getString(numberIndex)
                        if (idIndex != -1) contactId = cursor.getString(idIndex)
                    }
                }

                var email: String? = null
                if (contactId != null) {
                    val emailProjection = arrayOf(ContactsContract.CommonDataKinds.Email.ADDRESS)
                    contentResolver.query(
                        ContactsContract.CommonDataKinds.Email.CONTENT_URI,
                        emailProjection,
                        "${ContactsContract.CommonDataKinds.Email.CONTACT_ID} = ?",
                        arrayOf(contactId),
                        null
                    )?.use { emailCursor ->
                        if (emailCursor.moveToFirst()) {
                            val emailIndex = emailCursor.getColumnIndex(ContactsContract.CommonDataKinds.Email.ADDRESS)
                            if (emailIndex != -1) email = emailCursor.getString(emailIndex)
                        }
                    }
                }

                val resultMap = HashMap<String, Any?>()
                resultMap["name"] = name ?: ""
                resultMap["phone"] = phone ?: ""
                resultMap["email"] = email ?: ""
                result.success(resultMap)
            } catch (e: Exception) {
                result.error("QUERY_ERROR", e.localizedMessage, null)
            }
        }
    }
}
