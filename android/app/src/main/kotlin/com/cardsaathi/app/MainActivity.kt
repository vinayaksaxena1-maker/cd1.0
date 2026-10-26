package com.cardsaathi.app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.provider.ContactsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "com.cardsaathi/contact_picker"
    private val requestCodePickContact = 2026
    private var pendingResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
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
