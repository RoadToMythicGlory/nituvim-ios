import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:permission_handler/permission_handler.dart'; // Commented for Windows
import 'package:path/path.dart' as path;

import '../utils/constants.dart';

/// Service for managing file operations (Windows compatible version)
class FileManager {
  static const String _logTag = 'FileManager';
  
  /// Pick Excel file from device
  Future<String?> pickExcelFile() async {
    try {
      print('[$_logTag] פותח בוחר קבצים...');
      
      // No permission request needed on Windows/Desktop
      // final permissionStatus = await Permission.storage.request();
      // if (permissionStatus != PermissionStatus.granted) {
      //   print('[$_logTag] אין הרשאה לגישה לקבצים');
      //   return null;
      // }
      
      // Pick file
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: AppConstants.supportedExcelExtensions,
        allowMultiple: false,
        withData: false,
        withReadStream: false,
      );
      
      if (result != null && result.files.isNotEmpty) {
        final filePath = result.files.first.path;
        if (filePath != null) {
          print('[$_logTag] נבחר קובץ: $filePath');
          
          // Validate file
          if (await _validateExcelFile(filePath)) {
            return filePath;
          } else {
            print('[$_logTag] קובץ לא תקין');
            return null;
          }
        }
      }
      
      print('[$_logTag] לא נבחר קובץ');
      return null;
      
    } catch (e) {
      print('[$_logTag] שגיאה בבחירת קובץ: $e');
      return null;
    }
  }
  
  /// Validate Excel file
  Future<bool> _validateExcelFile(String filePath) async {
    try {
      final file = File(filePath);
      
      // Check if exists
      if (!await file.exists()) {
        return false;
      }
      
      // Check file size
      final fileSize = await file.length();
      if (fileSize > AppConstants.maxFileSizeMB * 1024 * 1024) {
        print('[$_logTag] קובץ גדול מדי: ${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB');
        return false;
      }
      
      if (fileSize == 0) {
        print('[$_logTag] קובץ ריק');
        return false;
      }
      
      // Check extension
      final extension = path.extension(filePath).toLowerCase();
      if (!AppConstants.supportedExcelExtensions.contains(extension.replaceFirst('.', ''))) {
        print('[$_logTag] סוג קובץ לא נתמך: $extension');
        return false;
      }
      
      print('[$_logTag] קובץ תקין: ${(fileSize / 1024 / 1024).toStringAsFixed(1)} MB');
      return true;
      
    } catch (e) {
      print('[$_logTag] שגיאה בבדיקת קובץ: $e');
      return false;
    }
  }
  
  /// Get documents directory for saving files
  Future<String?> getDocumentsDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } catch (e) {
      print('[$_logTag] שגיאה בקבלת תיקיית מסמכים: $e');
      // Fallback for Windows
      try {
        final directory = await getDownloadsDirectory();
        return directory?.path;
      } catch (e2) {
        print('[$_logTag] שגיאה בקבלת תיקיית הורדות: $e2');
        return null;
      }
    }
  }
  
  /// Get temporary directory for processing
  Future<String?> getTemporaryDirectory() async {
    try {
      final directory = await getTemporaryDirectory();
      return directory.path;
    } catch (e) {
      print('[$_logTag] שגיאה בקבלת תיקיית זמנית: $e');
      return null;
    }
  }
  
  /// Create app-specific directory
  Future<String?> createAppDirectory(String dirName) async {
    try {
      // Try documents directory first
      Directory? baseDir;
      try {
        baseDir = await getApplicationDocumentsDirectory();
      } catch (e) {
        // Fallback to downloads on Windows
        baseDir = await getDownloadsDirectory();
      }
      
      if (baseDir == null) {
        print('[$_logTag] לא ניתן לקבל תיקיית בסיס');
        return null;
      }
      
      final appDir = Directory(path.join(baseDir.path, 'NituvimAI', dirName));
      
      if (!await appDir.exists()) {
        await appDir.create(recursive: true);
        print('[$_logTag] נוצרה תיקייה: ${appDir.path}');
      }
      
      return appDir.path;
    } catch (e) {
      print('[$_logTag] שגיאה ביצירת תיקייה: $e');
      return null;
    }
  }
  
  /// Save file to app directory
  Future<String?> saveFileToAppDirectory(String sourceFilePath, String targetFileName) async {
    try {
      final appDir = await createAppDirectory('exports');
      if (appDir == null) return null;
      
      final sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        print('[$_logTag] קובץ מקור לא נמצא: $sourceFilePath');
        return null;
      }
      
      final targetPath = path.join(appDir, targetFileName);
      final targetFile = await sourceFile.copy(targetPath);
      
      print('[$_logTag] קובץ נשמר: $targetPath');
      return targetFile.path;
      
    } catch (e) {
      print('[$_logTag] שגיאה בשמירת קובץ: $e');
      return null;
    }
  }
  
  /// Share file using Windows/Desktop share
  Future<bool> shareFile(String filePath, {String? subject}) async {
    try {
      print('[$_logTag] משתף קובץ: $filePath');
      
      final file = File(filePath);
      if (!await file.exists()) {
        print('[$_logTag] קובץ לא נמצא לשיתוף');
        return false;
      }
      
      // Create XFile for sharing
      final xFile = XFile(filePath);
      
      // Share with subject if provided
      if (subject != null) {
        await Share.shareXFiles(
          [xFile],
          subject: subject,
          text: 'דוח ניתובים מעובד מ-Nituvim AI',
        );
      } else {
        await Share.shareXFiles([xFile]);
      }
      
      print('[$_logTag] קובץ שותף בהצלחה');
      return true;
      
    } catch (e) {
      print('[$_logTag] שגיאה בשיתוף קובץ: $e');
      // On Windows, if sharing fails, try opening file location
      try {
        final fileDir = path.dirname(filePath);
        await Process.run('explorer', [fileDir]);
        print('[$_logTag] נפתחה תיקיית הקובץ');
        return true;
      } catch (e2) {
        print('[$_logTag] שגיאה בפתיחת תיקייה: $e2');
        return false;
      }
    }
  }
  
  /// Get file info
  Future<Map<String, dynamic>?> getFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return null;
      
      final stat = await file.stat();
      
      return {
        'path': filePath,
        'name': path.basename(filePath),
        'size': stat.size,
        'sizeFormatted': _formatFileSize(stat.size),
        'modified': stat.modified,
        'extension': path.extension(filePath),
        'type': _getFileType(filePath),
      };
      
    } catch (e) {
      print('[$_logTag] שגיאה בקבלת מידע קובץ: $e');
      return null;
    }
  }
  
  /// Format file size for display
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
  
  /// Get file type description
  String _getFileType(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    switch (extension) {
      case '.xlsx':
        return 'Excel Workbook';
      case '.xls':
        return 'Excel Legacy';
      default:
        return 'Unknown';
    }
  }
  
  /// Delete file
  Future<bool> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        print('[$_logTag] קובץ נמחק: $filePath');
        return true;
      }
      return false;
    } catch (e) {
      print('[$_logTag] שגיאה במחיקת קובץ: $e');
      return false;
    }
  }
  
  /// Clean up temporary files
  Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      if (tempDir != null) {
        final dir = Directory(tempDir);
        if (await dir.exists()) {
          final files = await dir.list().toList();
          for (final file in files) {
            if (file is File && file.path.endsWith('.xlsx')) {
              try {
                await file.delete();
                print('[$_logTag] נמחק קובץ זמני: ${file.path}');
              } catch (e) {
                print('[$_logTag] שגיאה במחיקת קובץ זמני: $e');
              }
            }
          }
        }
      }
    } catch (e) {
      print('[$_logTag] שגיאה בניקוי קבצים זמניים: $e');
    }
  }
  
  /// List files in app directory
  Future<List<Map<String, dynamic>>> listAppFiles() async {
    try {
      final appDir = await createAppDirectory('exports');
      if (appDir == null) return [];
      
      final dir = Directory(appDir);
      if (!await dir.exists()) return [];
      
      final files = await dir.list().toList();
      final List<Map<String, dynamic>> fileList = [];
      
      for (final file in files) {
        if (file is File) {
          final info = await getFileInfo(file.path);
          if (info != null) {
            fileList.add(info);
          }
        }
      }
      
      // Sort by modification date (newest first)
      fileList.sort((a, b) => b['modified'].compareTo(a['modified']));
      
      return fileList;
      
    } catch (e) {
      print('[$_logTag] שגיאה בקבלת רשימת קבצים: $e');
      return [];
    }
  }
  
  /// Check available storage space
  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final docsDir = await getApplicationDocumentsDirectory();
      final stat = await docsDir.stat();
      
      // Note: iOS doesn't provide easy access to storage info
      // This is a simplified implementation
      return {
        'documentsPath': docsDir.path,
        'available': 'N/A', // iOS limitation
        'total': 'N/A',     // iOS limitation
        'used': 'N/A',      // iOS limitation
      };
      
    } catch (e) {
      print('[$_logTag] שגיאה בקבלת מידע אחסון: $e');
      return {};
    }
  }
  
  /// Export file with custom name and location
  Future<String?> exportFileWithName(
    String sourceFilePath,
    String fileName, {
    String? customDir,
  }) async {
    try {
      final targetDir = customDir ?? await createAppDirectory('exports');
      if (targetDir == null) return null;
      
      // Ensure file has proper extension
      final fileNameWithExt = fileName.endsWith('.xlsx') ? fileName : '$fileName.xlsx';
      final targetPath = path.join(targetDir, fileNameWithExt);
      
      final sourceFile = File(sourceFilePath);
      if (!await sourceFile.exists()) {
        return null;
      }
      
      final targetFile = await sourceFile.copy(targetPath);
      print('[$_logTag] קובץ יוצא: ${targetFile.path}');
      
      return targetFile.path;
      
    } catch (e) {
      print('[$_logTag] שגיאה בייצוא קובץ: $e');
      return null;
    }
  }
} 