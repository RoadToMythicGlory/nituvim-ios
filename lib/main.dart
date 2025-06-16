import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'screens/home_screen.dart';
import 'services/excel_processor.dart';
import 'services/file_manager.dart';
import 'utils/constants.dart';

void main() {
  runApp(const NituvimApp());
}

class NituvimApp extends StatelessWidget {
  const NituvimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ExcelProcessor>(create: (_) => ExcelProcessor()),
        Provider<FileManager>(create: (_) => FileManager()),
      ],
      child: MaterialApp(
        title: 'ניתובים AI',
        debugShowCheckedModeBanner: false,
        
        // Hebrew RTL Support
        locale: const Locale('he', 'IL'),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('he', 'IL'), // Hebrew
          Locale('en', 'US'), // English fallback
        ],
        
        // iOS-style theme
        theme: ThemeData.light().copyWith(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          
          // Hebrew-friendly typography
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          
          // iOS-style app bar
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.textPrimary,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          
          // Card styling
          cardTheme: CardTheme(
            color: AppColors.surface,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          
          // Button styling
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              textStyle: const TextStyle(
                fontFamily: 'Heebo',
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          
          // Input decoration
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.inputBackground,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            labelStyle: const TextStyle(
              fontFamily: 'Heebo',
              color: AppColors.textSecondary,
            ),
            hintStyle: const TextStyle(
              fontFamily: 'Heebo',
              color: AppColors.textHint,
            ),
          ),
        ),
        
        // Dark theme for system dark mode
        darkTheme: ThemeData.dark().copyWith(
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          scaffoldBackgroundColor: AppColors.backgroundDark,
          cardColor: AppColors.surfaceDark,
          
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimaryDark,
            ),
            headlineMedium: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryDark,
            ),
            bodyLarge: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 16,
              color: AppColors.textPrimaryDark,
            ),
            bodyMedium: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 14,
              color: AppColors.textSecondaryDark,
            ),
          ),
          
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surfaceDark,
            foregroundColor: AppColors.textPrimaryDark,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontFamily: 'Heebo',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryDark,
            ),
          ),
        ),
        
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
} 