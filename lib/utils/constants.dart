import 'package:flutter/material.dart';

/// App Constants and Styling
class AppConstants {
  // App Info
  static const String appName = 'ניתובים AI';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'מעבד אקסל מתקדם לניתובים';
  
  // File Extensions
  static const List<String> supportedExcelExtensions = ['xlsx', 'xls'];
  static const List<String> exportFormats = ['xlsx'];
  
  // Date Formats
  static const String dateFormat = 'dd/MM/yyyy';
  static const String timeFormat = 'HH:mm';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  
  // Broadcast Day Logic
  static const int broadcastDayStartHour = 7; // 07:00
  static const int broadcastDayStartMinute = 0;
  
  // File Size Limits
  static const int maxFileSizeMB = 50;
  static const int maxRowsToProcess = 100000;
  
  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
}

/// Color Scheme
class AppColors {
  // Primary Colors (matching original app's blue theme)
  static const Color primary = Color(0xFF00BFFF);           // Cyan blue
  static const Color primaryDark = Color(0xFF0099CC);       // Darker blue
  static const Color primaryLight = Color(0xFF4DD0FF);      // Lighter blue
  
  // Background Colors
  static const Color background = Color(0xFFF8F9FA);        // Light gray
  static const Color backgroundDark = Color(0xFF0A0A0A);    // Dark background
  static const Color surface = Color(0xFFFFFFFF);           // White
  static const Color surfaceDark = Color(0xFF1A1A1A);       // Dark surface
  
  // Text Colors
  static const Color textPrimary = Color(0xFF2C3E50);       // Dark blue-gray
  static const Color textSecondary = Color(0xFF7F8C8D);     // Medium gray
  static const Color textHint = Color(0xFFBDC3C7);          // Light gray
  
  // Dark Theme Text Colors
  static const Color textPrimaryDark = Color(0xFFFFFFFF);   // White
  static const Color textSecondaryDark = Color(0xFFB0BEC5); // Light gray
  static const Color textHintDark = Color(0xFF78909C);      // Medium gray
  
  // Status Colors
  static const Color success = Color(0xFF27AE60);           // Green
  static const Color warning = Color(0xFFF39C12);           // Orange
  static const Color error = Color(0xFFE74C3C);             // Red
  static const Color info = Color(0xFF3498DB);              // Blue
  
  // Accent Colors (matching original neon theme)
  static const Color accent1 = Color(0xFF00FF00);           // Neon green
  static const Color accent2 = Color(0xFFFF6B6B);           // Coral red
  static const Color accent3 = Color(0xFF9B59B6);           // Purple
  
  // UI Element Colors
  static const Color border = Color(0xFFE1E8ED);            // Light border
  static const Color borderDark = Color(0xFF37474F);        // Dark border
  static const Color inputBackground = Color(0xFFF5F7FA);   // Input background
  static const Color inputBackgroundDark = Color(0xFF263238); // Dark input
  
  // Card and Shadow Colors
  static const Color cardShadow = Color(0x1A000000);        // Light shadow
  static const Color cardShadowDark = Color(0x40000000);    // Dark shadow
}

/// Text Styles
class AppTextStyles {
  // Headers
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.2,
  );
  
  static const TextStyle h2 = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );
  
  static const TextStyle h3 = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );
  
  // Body Text
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );
  
  // Button Text
  static const TextStyle buttonLarge = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  static const TextStyle buttonMedium = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
  
  // Special Text
  static const TextStyle caption = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    height: 1.3,
  );
  
  static const TextStyle overline = TextStyle(
    fontFamily: 'Heebo',
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    letterSpacing: 0.5,
    height: 1.6,
  );
}

/// Hebrew Strings
class HebrewStrings {
  // Main Screen
  static const String appTitle = 'ניתובים AI';
  static const String selectFile = 'בחר קובץ';
  static const String selectFolder = 'בחר תיקייה';
  static const String processFile = 'עבד קובץ';
  static const String exportFile = 'ייצא קובץ';
  static const String shareFile = 'שתף קובץ';
  
  // File Operations
  static const String fileSelected = 'קובץ נבחר';
  static const String fileProcessing = 'מעבד קובץ...';
  static const String fileProcessed = 'קובץ עובד בהצלחה';
  static const String noFileSelected = 'לא נבחר קובץ';
  static const String invalidFile = 'קובץ לא תקין';
  
  // Date Selection
  static const String selectDateRange = 'בחר טווח תאריכים';
  static const String fromDate = 'מתאריך';
  static const String toDate = 'עד תאריך';
  static const String broadcastDayLogic = 'לוגיקת יום שידור';
  static const String newLogic = 'חדש (07:00-06:59)';
  static const String oldLogic = 'ישן (00:00-23:59)';
  
  // Processing Options
  static const String processingOptions = 'אפשרויות עיבוד';
  static const String filterByDate = 'סנן לפי תאריך';
  static const String showStatistics = 'הצג סטטיסטיקות';
  static const String debugMode = 'מצב דיבוג';
  
  // Results
  static const String resultsTitle = 'תוצאות עיבוד';
  static const String totalRows = 'סה"כ שורות';
  static const String filteredRows = 'שורות מסוננות';
  static const String processingTime = 'זמן עיבוד';
  
  // Errors
  static const String errorTitle = 'שגיאה';
  static const String fileNotFound = 'קובץ לא נמצא';
  static const String processingError = 'שגיאה בעיבוד';
  static const String exportError = 'שגיאה בייצוא';
  static const String permissionError = 'אין הרשאה לקובץ';
  
  // Success Messages
  static const String successTitle = 'הצלחה';
  static const String fileExported = 'קובץ יוצא בהצלחה';
  static const String fileShared = 'קובץ שותף בהצלחה';
  
  // Buttons
  static const String ok = 'אישור';
  static const String cancel = 'ביטול';
  static const String retry = 'נסה שוב';
  static const String close = 'סגור';
  
  // Settings
  static const String settings = 'הגדרות';
  static const String about = 'אודות';
  static const String version = 'גרסה';
  static const String developer = 'מפתח';
}

/// Spacing and Sizing
class AppSizes {
  // Padding
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  
  // Margins
  static const double marginXS = 4.0;
  static const double marginS = 8.0;
  static const double marginM = 16.0;
  static const double marginL = 24.0;
  static const double marginXL = 32.0;
  
  // Border Radius
  static const double radiusS = 4.0;
  static const double radiusM = 8.0;
  static const double radiusL = 12.0;
  static const double radiusXL = 16.0;
  
  // Icon Sizes
  static const double iconS = 16.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;
  
  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;
  static const double buttonHeightXL = 56.0;
} 