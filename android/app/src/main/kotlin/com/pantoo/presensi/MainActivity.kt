package com.pantoo.presensi

import android.content.ContentValues
import android.media.MediaScannerConnection
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.io.IOException

class MainActivity : FlutterActivity() {
    private val downloadsChannel = "com.pantoo.presensi/downloads"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, downloadsChannel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "savePdfToDownloads" -> {
                        val bytes = call.argument<ByteArray>("bytes")
                        val fileNameArg = call.argument<String>("fileName")
                        val subFolderArg = call.argument<String>("subFolder")

                        if (bytes == null || bytes.isEmpty()) {
                            result.error("INVALID_BYTES", "PDF data kosong", null)
                            return@setMethodCallHandler
                        }

                        val fileName = sanitizeFileName(fileNameArg ?: "slip_gaji.pdf")
                        val subFolder = sanitizeSubFolder(subFolderArg ?: "Pantoo")

                        try {
                            val savedLocation =
                                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                                    saveToMediaStore(bytes, fileName, subFolder)
                                } else {
                                    saveToLegacyDownloads(bytes, fileName, subFolder)
                                }
                            result.success(savedLocation)
                        } catch (e: Exception) {
                            result.error(
                                "SAVE_FAILED",
                                e.message ?: "Gagal menyimpan file PDF",
                                null,
                            )
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun sanitizeFileName(fileName: String): String {
        val trimmed = fileName.trim().ifEmpty { "slip_gaji.pdf" }
        val cleaned = trimmed.replace(Regex("[\\\\/:*?\"<>|]"), "_")
        return if (cleaned.lowercase().endsWith(".pdf")) cleaned else "$cleaned.pdf"
    }

    private fun sanitizeSubFolder(folderName: String): String {
        val trimmed = folderName.trim().ifEmpty { "Pantoo" }
        return trimmed.replace(Regex("[\\\\/:*?\"<>|]"), "_")
    }

    @Throws(IOException::class)
    private fun saveToMediaStore(
        bytes: ByteArray,
        fileName: String,
        subFolder: String,
    ): String {
        val relativePath = "${Environment.DIRECTORY_DOWNLOADS}/$subFolder"
        val values =
            ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, "application/pdf")
                put(MediaStore.Downloads.RELATIVE_PATH, relativePath)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }

        val uri =
            contentResolver.insert(MediaStore.Downloads.EXTERNAL_CONTENT_URI, values)
                ?: throw IOException("Tidak bisa membuat file di Downloads")

        contentResolver.openOutputStream(uri)?.use { output ->
            output.write(bytes)
            output.flush()
        } ?: throw IOException("Tidak bisa menulis file PDF")

        values.clear()
        values.put(MediaStore.Downloads.IS_PENDING, 0)
        contentResolver.update(uri, values, null, null)

        return uri.toString()
    }

    @Suppress("DEPRECATION")
    @Throws(IOException::class)
    private fun saveToLegacyDownloads(
        bytes: ByteArray,
        fileName: String,
        subFolder: String,
    ): String {
        val downloadsDir =
            Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val targetDir = File(downloadsDir, subFolder)
        if (!targetDir.exists() && !targetDir.mkdirs()) {
            throw IOException("Tidak bisa membuat folder Downloads/$subFolder")
        }

        val outputFile = createUniqueFile(targetDir, fileName)
        FileOutputStream(outputFile).use { stream ->
            stream.write(bytes)
            stream.flush()
        }

        MediaScannerConnection.scanFile(
            this,
            arrayOf(outputFile.absolutePath),
            arrayOf("application/pdf"),
            null,
        )

        return outputFile.absolutePath
    }

    private fun createUniqueFile(directory: File, fileName: String): File {
        val dotIndex = fileName.lastIndexOf('.')
        val baseName = if (dotIndex >= 0) fileName.substring(0, dotIndex) else fileName
        val extension = if (dotIndex >= 0) fileName.substring(dotIndex) else ""

        var candidate = File(directory, fileName)
        var index = 1
        while (candidate.exists()) {
            candidate = File(directory, "${baseName}_$index$extension")
            index++
        }
        return candidate
    }
}
