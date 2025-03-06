package dev.knottx.flutter_image_gallery_saver

import android.content.ContentValues
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import android.webkit.MimeTypeMap
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.FileInputStream
import java.io.IOException
import java.io.OutputStream


class FlutterImageGallerySaverPlugin : FlutterPlugin, MethodCallHandler {

    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "dev.knottx.flutter_image_gallery_saver")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "save_image" -> {
                val imageBytes = call.argument<ByteArray>("image_bytes")
                val fileName = call.argument<String>("file_name") ?: "${System.currentTimeMillis()}"
                if (imageBytes == null) {
                    result.error("INVALID_ARGUMENTS", "No image bytes provided", null)
                    return
                }
                val bmp = BitmapFactory.decodeByteArray(imageBytes, 0, imageBytes.size)
                if (bmp == null) {
                    result.error("INVALID_ARGUMENTS", "Failed to decode image bytes", null)
                    return
                }
                try {
                    saveImage(bmp, fileName)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("SAVE_FAILED", e.message, null)
                }
            }
            "save_file" -> {
                val filePath = call.argument<String>("file_path")
                val fileName = call.argument<String>("file_name") ?: "${System.currentTimeMillis()}"
                if (filePath == null) {
                    result.error("INVALID_ARGUMENTS", "No file path provided", null)
                    return
                }
                try {
                    saveFile(filePath, fileName)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("SAVE_FAILED", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    private fun saveImage(bmp: Bitmap,  fileName: String) {
        val fileUri: Uri = generateUri(fileName, "jpg")
            ?: throw Exception("Failed to generate file URI")
        val fos: OutputStream = applicationContext?.contentResolver?.openOutputStream(fileUri)
            ?: throw Exception("Failed to open output stream")
        try {
            if (!bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos)) {
                throw Exception("Bitmap compression failed")
            }
            fos.flush()
            sendBroadcast(applicationContext!!, fileUri)
        } catch (e: IOException) {
            throw e
        } finally {
            fos.close()
            bmp.recycle()
        }
    }

    private fun saveFile(filePath: String, fileName: String) {
        val context = applicationContext ?: throw Exception("Application context is null")
        val originalFile = File(filePath)
        if (!originalFile.exists()) throw Exception("$filePath does not exist")
        val fileUri = generateUri(fileName, originalFile.extension)
            ?: throw Exception("Failed to generate file URI")
        FileInputStream(originalFile).use { fileInputStream ->
            context.contentResolver.openOutputStream(fileUri)?.use { outputStream ->
                val buffer = ByteArray(10240)
                var count: Int
                while (fileInputStream.read(buffer).also { count = it } > 0) {
                    outputStream.write(buffer, 0, count)
                }
                outputStream.flush()
            } ?: throw Exception("Failed to open output stream")
        }
    }

    private fun generateUri(fileName: String,extension: String = ""): Uri? {
        val mimeType = getMIMEType(extension)
        val isVideo = mimeType?.startsWith("video") == true

        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // For Android 10 and above, use the MediaStore API.
            val collectionUri = if (isVideo) {
                MediaStore.Video.Media.EXTERNAL_CONTENT_URI
            } else {
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            }
            val relativePath = if (isVideo) Environment.DIRECTORY_MOVIES else Environment.DIRECTORY_PICTURES
            val values = ContentValues().apply {
                put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
                put(MediaStore.MediaColumns.RELATIVE_PATH, relativePath)
                mimeType?.let {
                    val mimeKey = if (isVideo) MediaStore.Video.Media.MIME_TYPE else MediaStore.Images.Media.MIME_TYPE
                    put(mimeKey, it)
                }
            }
            applicationContext?.contentResolver?.insert(collectionUri, values)
        } else {
            // For Android versions below Q, use the external storage.
            val publicDir = if (isVideo) {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_MOVIES)
            } else {
                Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES)
            }
            val storePath = publicDir.absolutePath
            val appDir = File(storePath).apply {
                if (!exists()) mkdirs()
            }
            val file = if (extension.isNotBlank()) {
                File(appDir, "$fileName.${extension.lowercase()}")
            } else {
                File(appDir, fileName)
            }
            Uri.fromFile(file)
        }
    }

    private fun getMIMEType(extension: String): String? {
        return extension.takeIf { it.isNotBlank() }
            ?.lowercase()
            ?.let { MimeTypeMap.getSingleton().getMimeTypeFromExtension(it) }
    }

    private fun sendBroadcast(context: Context, uri: Uri) {
        val intent = Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE).apply {
            data = uri
        }
        context.sendBroadcast(intent)
    }
}
