import 'dart:io';
import 'dart:typed_data';
import 'package:excel/excel.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;

import '../models/excel_data.dart';
import '../utils/constants.dart';

/// Main service for processing Excel files
class ExcelProcessor {
  static const String _logTag = 'ExcelProcessor';
  
  /// Load Excel file from file path
  Future<ExcelFileData?> loadExcelFile(String filePath) async {
    try {
      print('[$_logTag] טוען קובץ: $filePath');
      
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('קובץ לא נמצא: $filePath');
      }
      
      // Check file size
      final fileSize = await file.length();
      if (fileSize > AppConstants.maxFileSizeMB * 1024 * 1024) {
        throw Exception('קובץ גדול מדי (מעל ${AppConstants.maxFileSizeMB} MB)');
      }
      
      // Read file bytes
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      
      // Get first sheet
      if (excel.tables.isEmpty) {
        throw Exception('לא נמצאו גליונות בקובץ');
      }
      
      final sheetName = excel.tables.keys.first;
      final sheet = excel.tables[sheetName]!;
      
      // Extract data
      final List<List<dynamic>> rows = [];
      final List<String> headers = [];
      
      bool headerProcessed = false;
      int dataRowCount = 0;
      
      for (final row in sheet.rows) {
        if (dataRowCount >= AppConstants.maxRowsToProcess) {
          print('[$_logTag] הגבלת ${AppConstants.maxRowsToProcess} שורות הושגה');
          break;
        }
        
        // Convert row cells to values
        final List<dynamic> rowValues = row.map((cell) => 
          cell?.value ?? '').toList();
        
        // Skip empty rows
        if (rowValues.every((cell) => cell == null || cell.toString().trim().isEmpty)) {
          continue;
        }
        
        if (!headerProcessed) {
          // First non-empty row is headers
          headers.addAll(rowValues.map((cell) => cell.toString()));
          headerProcessed = true;
        } else {
          // Data row
          rows.add(rowValues);
          dataRowCount++;
        }
      }
      
      print('[$_logTag] נטען בהצלחה: ${rows.length} שורות, ${headers.length} עמודות');
      
      return ExcelFileData(
        fileName: path.basename(filePath),
        filePath: filePath,
        rows: rows,
        headers: headers,
        lastModified: await file.lastModified(),
        fileSize: fileSize,
      );
      
    } catch (e) {
      print('[$_logTag] שגיאה בטעינת קובץ: $e');
      return null;
    }
  }
  
  /// Process Excel data with filtering
  Future<ProcessedExcelData?> processExcelData(
    ExcelFileData excelData,
    FilterSettings filterSettings,
  ) async {
    try {
      print('[$_logTag] מתחיל עיבוד עם ${filterSettings.logicDescription}');
      final stopwatch = Stopwatch()..start();
      
      List<List<dynamic>> filteredRows;
      final List<String> errors = [];
      final List<String> warnings = [];
      
      // Choose processing logic
      if (filterSettings.logic == BroadcastDayLogic.newLogic) {
        filteredRows = await _processWithNewLogic(
          excelData, 
          filterSettings,
          errors,
          warnings,
        );
      } else {
        filteredRows = await _processWithOldLogic(
          excelData, 
          filterSettings,
          errors,
          warnings,
        );
      }
      
      stopwatch.stop();
      
      // Calculate statistics
      final statistics = ProcessingStatistics(
        originalRows: excelData.totalRows,
        filteredRows: filteredRows.length,
        removedRows: excelData.totalRows - filteredRows.length,
        processingTime: stopwatch.elapsed,
        errors: errors,
        warnings: warnings,
      );
      
      print('[$_logTag] עיבוד הושלם: ${statistics.toString()}');
      
      return ProcessedExcelData(
        originalData: excelData,
        filteredRows: filteredRows,
        filterSettings: filterSettings,
        statistics: statistics,
        processedAt: DateTime.now(),
      );
      
    } catch (e) {
      print('[$_logTag] שגיאה בעיבוד: $e');
      return null;
    }
  }
  
  /// Process with new broadcast day logic (07:00-06:59)
  Future<List<List<dynamic>>> _processWithNewLogic(
    ExcelFileData excelData,
    FilterSettings filterSettings,
    List<String> errors,
    List<String> warnings,
  ) async {
    print('[$_logTag] מעבד עם לוגיקה חדשה (07:00-06:59)');
    
    final List<BroadcastDayEntry> broadcastEntries = [];
    int skippedRows = 0;
    
    // Convert rows to broadcast day entries
    for (int i = 0; i < excelData.rows.length; i++) {
      final row = excelData.rows[i];
      
      try {
        final dateTime = _parseDateTime(row);
        if (dateTime == null) {
          skippedRows++;
          continue;
        }
        
        // Calculate broadcast day
        final broadcastDay = _calculateBroadcastDay(dateTime);
        
        // Create row data map
        final Map<String, dynamic> rowData = {};
        for (int j = 0; j < row.length && j < excelData.headers.length; j++) {
          rowData[excelData.headers[j]] = row[j];
        }
        
        broadcastEntries.add(BroadcastDayEntry(
          originalDateTime: dateTime,
          broadcastDay: broadcastDay,
          originalRow: i,
          rowData: rowData,
        ));
        
      } catch (e) {
        errors.add('שגיאה בשורה ${i + 1}: $e');
        skippedRows++;
      }
    }
    
    if (skippedRows > 0) {
      warnings.add('דולגו $skippedRows שורות עקב תאריכים לא תקינים');
    }
    
    print('[$_logTag] נוצרו ${broadcastEntries.length} רשומות יום שידור');
    
    // Filter by date range if specified
    List<BroadcastDayEntry> filteredEntries = broadcastEntries;
    
    if (filterSettings.hasDateFilter) {
      filteredEntries = broadcastEntries.where((entry) {
        final broadcastDay = entry.broadcastDay;
        return broadcastDay.isAfter(filterSettings.startDate!.subtract(const Duration(days: 1))) &&
               broadcastDay.isBefore(filterSettings.endDate!.add(const Duration(days: 1)));
      }).toList();
      
      print('[$_logTag] סינון לפי תאריכים: ${filteredEntries.length} רשומות נשארו');
    }
    
    // Convert back to row format
    return filteredEntries.map((entry) => excelData.rows[entry.originalRow]).toList();
  }
  
  /// Process with old calendar day logic (00:00-23:59)
  Future<List<List<dynamic>>> _processWithOldLogic(
    ExcelFileData excelData,
    FilterSettings filterSettings,
    List<String> errors,
    List<String> warnings,
  ) async {
    print('[$_logTag] מעבד עם לוגיקה ישנה (00:00-23:59)');
    
    if (!filterSettings.hasDateFilter) {
      // No filtering, return all rows
      return List.from(excelData.rows);
    }
    
    final List<List<dynamic>> filteredRows = [];
    int skippedRows = 0;
    
    for (int i = 0; i < excelData.rows.length; i++) {
      final row = excelData.rows[i];
      
      try {
        final dateTime = _parseDateTime(row);
        if (dateTime == null) {
          skippedRows++;
          continue;
        }
        
        // Check if date falls within range (calendar day logic)
        final date = DateTime(dateTime.year, dateTime.month, dateTime.day);
        final startDate = DateTime(filterSettings.startDate!.year, 
                                 filterSettings.startDate!.month, 
                                 filterSettings.startDate!.day);
        final endDate = DateTime(filterSettings.endDate!.year, 
                               filterSettings.endDate!.month, 
                               filterSettings.endDate!.day);
        
        if ((date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) &&
            (date.isBefore(endDate) || date.isAtSameMomentAs(endDate))) {
          filteredRows.add(row);
        }
        
      } catch (e) {
        errors.add('שגיאה בשורה ${i + 1}: $e');
        skippedRows++;
      }
    }
    
    if (skippedRows > 0) {
      warnings.add('דולגו $skippedRows שורות עקב תאריכים לא תקינים');
    }
    
    print('[$_logTag] סינון הושלם: ${filteredRows.length} שורות נשארו');
    return filteredRows;
  }
  
  /// Parse date and time from a row
  DateTime? _parseDateTime(List<dynamic> row) {
    try {
      // Get date and time values from columns B and C (indices 1 and 2)
      if (row.length < 3) return null;
      
      final dateValue = row[ColumnMapping.dateColumnIndex];
      final timeValue = row[ColumnMapping.timeColumnIndex];
      
      if (dateValue == null || timeValue == null) return null;
      
      // Skip header rows
      if (_isHeaderValue(dateValue) || _isHeaderValue(timeValue)) {
        return null;
      }
      
      DateTime? date = _parseDate(dateValue);
      if (date == null) return null;
      
      final time = _parseTime(timeValue);
      if (time == null) return null;
      
      // Combine date and time
      return DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
        time.second,
      );
      
    } catch (e) {
      return null;
    }
  }
  
  /// Parse date value
  DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    
    try {
      // If it's already a DateTime
      if (value is DateTime) {
        return value;
      }
      
      // If it's a string, try various formats
      if (value is String) {
        final dateStr = value.trim();
        if (dateStr.isEmpty) return null;
        
        // Common Hebrew date formats
        final formats = [
          'dd/MM/yyyy',
          'dd.MM.yyyy',
          'dd-MM-yyyy',
          'yyyy-MM-dd',
          'dd/MM/yy',
          'dd.MM.yy',
        ];
        
        for (final format in formats) {
          try {
            return DateFormat(format).parse(dateStr);
          } catch (_) {
            continue;
          }
        }
        
        // Try general parsing
        return DateTime.tryParse(dateStr);
      }
      
      // If it's a number (Excel date serial number)
      if (value is num) {
        // Excel date starts from 1900-01-01
        final baseDate = DateTime(1900, 1, 1);
        return baseDate.add(Duration(days: value.toInt() - 2));
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Parse time value
  DateTime? _parseTime(dynamic value) {
    if (value == null) return null;
    
    try {
      // If it's already a DateTime, extract time
      if (value is DateTime) {
        return value;
      }
      
      // If it's a string
      if (value is String) {
        final timeStr = value.trim();
        if (timeStr.isEmpty) return null;
        
        // Try HH:mm format
        if (timeStr.contains(':')) {
          final parts = timeStr.split(':');
          if (parts.length >= 2) {
            final hour = int.tryParse(parts[0]);
            final minute = int.tryParse(parts[1]);
            if (hour != null && minute != null) {
              return DateTime(2000, 1, 1, hour, minute);
            }
          }
        }
        
        // Try to parse as time
        try {
          return DateFormat('HH:mm').parse(timeStr);
        } catch (_) {
          return DateFormat('H:mm').parse(timeStr);
        }
      }
      
      // If it's a fraction (Excel time format: 0.5 = 12:00)
      if (value is num && value >= 0 && value <= 1) {
        final totalMinutes = (value * 24 * 60).round();
        final hours = totalMinutes ~/ 60;
        final minutes = totalMinutes % 60;
        return DateTime(2000, 1, 1, hours, minutes);
      }
      
      return null;
    } catch (e) {
      return null;
    }
  }
  
  /// Check if value is a header (contains text like "תאריך", "שעה", etc.)
  bool _isHeaderValue(dynamic value) {
    if (value is! String) return false;
    
    final str = value.toString().toLowerCase();
    final headerKeywords = [
      'תאריך', 'date',
      'שעת שידור', 'שעת_שידור', 'שעה', 'time',
      'מערך שידורים', 'שבוע', 'unnamed'
    ];
    
    return headerKeywords.any((keyword) => str.contains(keyword));
  }
  
  /// Calculate broadcast day based on date/time and 07:00 cutoff
  DateTime _calculateBroadcastDay(DateTime dateTime) {
    if (dateTime.hour >= AppConstants.broadcastDayStartHour) {
      // Same day (07:00 or later)
      return DateTime(dateTime.year, dateTime.month, dateTime.day);
    } else {
      // Previous day (before 07:00)
      return DateTime(dateTime.year, dateTime.month, dateTime.day)
          .subtract(const Duration(days: 1));
    }
  }
  
  /// Export processed data to Excel file
  Future<String?> exportToExcel(
    ProcessedExcelData processedData,
    String outputPath,
  ) async {
    try {
      print('[$_logTag] מייצא קובץ ל: $outputPath');
      
      // Create new Excel workbook
      final excel = Excel.createExcel();
      excel.rename('Sheet1', 'ניתובים');
      final sheet = excel['ניתובים'];
      
      // Add headers
      for (int i = 0; i < processedData.headers.length; i++) {
        sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = processedData.headers[i];
      }
      
      // Add data rows
      for (int rowIndex = 0; rowIndex < processedData.filteredRows.length; rowIndex++) {
        final row = processedData.filteredRows[rowIndex];
        for (int colIndex = 0; colIndex < row.length; colIndex++) {
          sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: colIndex, 
            rowIndex: rowIndex + 1,
          )).value = row[colIndex];
        }
      }
      
      // Generate filename
      final dateRange = processedData.filterSettings.dateRangeString;
      final logicSuffix = processedData.filterSettings.logic == BroadcastDayLogic.newLogic 
          ? '(ימי-שידור-חדש)' : '(ימי-שידור-ישן)';
      final fileName = 'ניתובים $dateRange $logicSuffix.xlsx';
      final fullPath = path.join(outputPath, fileName);
      
      // Save file
      final file = File(fullPath);
      await file.writeAsBytes(excel.encode()!);
      
      print('[$_logTag] קובץ נשמר בהצלחה: $fullPath');
      return fullPath;
      
    } catch (e) {
      print('[$_logTag] שגיאה בייצוא: $e');
      return null;
    }
  }
  
  /// Get available date columns from Excel data
  List<String> getDateColumns(ExcelFileData excelData) {
    final dateColumns = <String>[];
    
    for (int i = 0; i < excelData.headers.length; i++) {
      final header = excelData.headers[i].toLowerCase();
      if (header.contains('תאריך') || 
          header.contains('date') ||
          header.contains('יום')) {
        dateColumns.add(excelData.headers[i]);
      }
    }
    
    // Add default columns if none found
    if (dateColumns.isEmpty && excelData.headers.length > 1) {
      dateColumns.add(excelData.headers[1]); // Column B
    }
    
    return dateColumns;
  }
  
  /// Analyze Excel data structure for debugging
  Map<String, dynamic> analyzeExcelData(ExcelFileData excelData) {
    final analysis = <String, dynamic>{};
    
    analysis['fileName'] = excelData.fileName;
    analysis['totalRows'] = excelData.totalRows;
    analysis['totalColumns'] = excelData.headers.length;
    analysis['headers'] = excelData.headers;
    
    // Sample first few rows
    final sampleRows = excelData.rows.take(3).toList();
    analysis['sampleData'] = sampleRows;
    
    // Analyze date columns
    final dateColumns = getDateColumns(excelData);
    analysis['detectedDateColumns'] = dateColumns;
    
    // Check for common issues
    final issues = <String>[];
    if (excelData.totalRows == 0) {
      issues.add('אין נתונים בקובץ');
    }
    if (excelData.headers.isEmpty) {
      issues.add('אין כותרות בקובץ');
    }
    if (dateColumns.isEmpty) {
      issues.add('לא נמצאו עמודות תאריך');
    }
    
    analysis['issues'] = issues;
    analysis['analyzedAt'] = DateTime.now().toIso8601String();
    
    return analysis;
  }
} 