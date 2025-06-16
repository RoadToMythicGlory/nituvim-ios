import 'dart:typed_data';

/// Represents an Excel file with its data and metadata
class ExcelFileData {
  final String fileName;
  final String filePath;
  final List<List<dynamic>> rows;
  final List<String> headers;
  final DateTime? lastModified;
  final int fileSize;
  
  const ExcelFileData({
    required this.fileName,
    required this.filePath,
    required this.rows,
    required this.headers,
    this.lastModified,
    required this.fileSize,
  });
  
  /// Total number of rows (excluding headers)
  int get totalRows => rows.length;
  
  /// Check if the file has data
  bool get hasData => rows.isNotEmpty;
  
  /// Get headers as a comma-separated string
  String get headersString => headers.join(', ');
  
  @override
  String toString() {
    return 'ExcelFileData(fileName: $fileName, rows: $totalRows, headers: ${headers.length})';
  }
}

/// Represents processed Excel data with filtering applied
class ProcessedExcelData {
  final ExcelFileData originalData;
  final List<List<dynamic>> filteredRows;
  final FilterSettings filterSettings;
  final ProcessingStatistics statistics;
  final DateTime processedAt;
  
  const ProcessedExcelData({
    required this.originalData,
    required this.filteredRows,
    required this.filterSettings,
    required this.statistics,
    required this.processedAt,
  });
  
  /// Number of filtered rows
  int get filteredRowCount => filteredRows.length;
  
  /// Check if any data remains after filtering
  bool get hasFilteredData => filteredRows.isNotEmpty;
  
  /// Get headers from original data
  List<String> get headers => originalData.headers;
  
  /// Calculate reduction percentage
  double get reductionPercentage {
    if (originalData.totalRows == 0) return 0.0;
    return ((originalData.totalRows - filteredRowCount) / originalData.totalRows) * 100;
  }
  
  @override
  String toString() {
    return 'ProcessedExcelData(original: ${originalData.totalRows}, filtered: $filteredRowCount, reduction: ${reductionPercentage.toStringAsFixed(1)}%)';
  }
}

/// Filter settings for Excel processing
class FilterSettings {
  final DateTime? startDate;
  final DateTime? endDate;
  final BroadcastDayLogic logic;
  final bool debugMode;
  final String? dateColumnName;
  final String? timeColumnName;
  
  const FilterSettings({
    this.startDate,
    this.endDate,
    required this.logic,
    this.debugMode = false,
    this.dateColumnName,
    this.timeColumnName,
  });
  
  /// Check if date filtering is enabled
  bool get hasDateFilter => startDate != null && endDate != null;
  
  /// Get date range as string
  String get dateRangeString {
    if (!hasDateFilter) return 'ללא סינון תאריכים';
    
    final start = startDate!.day.toString().padLeft(2, '0') + 
                  '/${startDate!.month.toString().padLeft(2, '0')}' +
                  '/${startDate!.year}';
    final end = endDate!.day.toString().padLeft(2, '0') + 
                '/${endDate!.month.toString().padLeft(2, '0')}' +
                '/${endDate!.year}';
    
    return '$start - $end';
  }
  
  /// Get logic description
  String get logicDescription {
    switch (logic) {
      case BroadcastDayLogic.newLogic:
        return 'לוגיקה חדשה (07:00-06:59)';
      case BroadcastDayLogic.oldLogic:
        return 'לוגיקה ישנה (00:00-23:59)';
    }
  }
  
  FilterSettings copyWith({
    DateTime? startDate,
    DateTime? endDate,
    BroadcastDayLogic? logic,
    bool? debugMode,
    String? dateColumnName,
    String? timeColumnName,
  }) {
    return FilterSettings(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      logic: logic ?? this.logic,
      debugMode: debugMode ?? this.debugMode,
      dateColumnName: dateColumnName ?? this.dateColumnName,
      timeColumnName: timeColumnName ?? this.timeColumnName,
    );
  }
}

/// Broadcast day logic options
enum BroadcastDayLogic {
  /// New logic: 07:00-06:59 (broadcast day)
  newLogic,
  /// Old logic: 00:00-23:59 (calendar day)
  oldLogic,
}

/// Statistics from processing
class ProcessingStatistics {
  final int originalRows;
  final int filteredRows;
  final int removedRows;
  final Duration processingTime;
  final Map<String, int> columnStatistics;
  final List<String> errors;
  final List<String> warnings;
  
  const ProcessingStatistics({
    required this.originalRows,
    required this.filteredRows,
    required this.removedRows,
    required this.processingTime,
    this.columnStatistics = const {},
    this.errors = const [],
    this.warnings = const [],
  });
  
  /// Check if processing had errors
  bool get hasErrors => errors.isNotEmpty;
  
  /// Check if processing had warnings
  bool get hasWarnings => warnings.isNotEmpty;
  
  /// Get reduction percentage
  double get reductionPercentage {
    if (originalRows == 0) return 0.0;
    return (removedRows / originalRows) * 100;
  }
  
  /// Get processing speed (rows per second)
  double get processingSpeed {
    if (processingTime.inMilliseconds == 0) return 0.0;
    return originalRows / (processingTime.inMilliseconds / 1000);
  }
  
  /// Get formatted processing time
  String get formattedProcessingTime {
    if (processingTime.inSeconds < 1) {
      return '${processingTime.inMilliseconds} ms';
    } else if (processingTime.inMinutes < 1) {
      return '${processingTime.inSeconds} שניות';
    } else {
      return '${processingTime.inMinutes} דקות ${processingTime.inSeconds % 60} שניות';
    }
  }
  
  @override
  String toString() {
    return 'ProcessingStatistics(original: $originalRows, filtered: $filteredRows, time: $formattedProcessingTime)';
  }
}

/// Represents a broadcast day entry (for new logic)
class BroadcastDayEntry {
  final DateTime originalDateTime;
  final DateTime broadcastDay;
  final int originalRow;
  final Map<String, dynamic> rowData;
  
  const BroadcastDayEntry({
    required this.originalDateTime,
    required this.broadcastDay,
    required this.originalRow,
    required this.rowData,
  });
  
  /// Check if this entry belongs to a broadcast day (07:00-06:59)
  bool belongsToBroadcastDay(DateTime targetDay) {
    final dayStart = DateTime(targetDay.year, targetDay.month, targetDay.day, 7);
    final dayEnd = DateTime(targetDay.year, targetDay.month, targetDay.day + 1, 6, 59, 59);
    
    return originalDateTime.isAfter(dayStart) && originalDateTime.isBefore(dayEnd);
  }
  
  /// Get formatted broadcast day
  String get formattedBroadcastDay {
    return '${broadcastDay.day.toString().padLeft(2, '0')}/${broadcastDay.month.toString().padLeft(2, '0')}/${broadcastDay.year}';
  }
  
  @override
  String toString() {
    return 'BroadcastDayEntry(original: $originalDateTime, broadcast: $formattedBroadcastDay)';
  }
}

/// Column mapping configuration (matching Python config)
class ColumnMapping {
  // Column positions from Python config
  static const Map<int, String> positionMapping = {
    0: 'program_id',        // Column A
    1: 'date',              // Column B - תאריך
    2: 'time',              // Column C - שעת שידור
    3: 'duration',          // Column D - משך
    4: 'program_name',      // Column E - שם תוכנית
    5: 'episode_name',      // Column F - שם פרק
    6: 'series_name',       // Column G - שם סדרה
    7: 'genre',             // Column H - ז'אנר
    8: 'description',       // Column I - תיאור
    9: 'actors',            // Column J - שחקנים
    10: 'director',         // Column K - במאי
    11: 'year',             // Column L - שנת הפקה
    12: 'country',          // Column M - ארץ הפקה
    13: 'language',         // Column N - שפה
    14: 'age_rating',       // Column O - דירוג גיל
  };
  
  /// Get Hebrew column name
  static String getHebrewColumnName(int position) {
    switch (position) {
      case 0: return 'מזהה תוכנית';
      case 1: return 'תאריך';
      case 2: return 'שעת שידור';
      case 3: return 'משך';
      case 4: return 'שם תוכנית';
      case 5: return 'שם פרק';
      case 6: return 'שם סדרה';
      case 7: return 'ז\'אנר';
      case 8: return 'תיאור';
      case 9: return 'שחקנים';
      case 10: return 'במאי';
      case 11: return 'שנת הפקה';
      case 12: return 'ארץ הפקה';
      case 13: return 'שפה';
      case 14: return 'דירוג גיל';
      default: return 'עמודה ${position + 1}';
    }
  }
  
  /// Get date column index
  static int get dateColumnIndex => 1;
  
  /// Get time column index
  static int get timeColumnIndex => 2;
} 