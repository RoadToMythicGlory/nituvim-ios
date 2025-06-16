# ניתובים AI - iOS App 📱

> Flutter iOS conversion of the Nituvim AI desktop application

## 🚀 Overview

This is a complete Flutter-based iOS conversion of the original Python desktop application. The app maintains all core functionality while providing a native iOS experience with Hebrew RTL support.

## ✨ Features

### Core Functionality (Preserved from Python app)
- 📊 **Excel File Processing** - Read and process `.xlsx` and `.xls` files
- 📅 **Advanced Date Filtering** - Two filtering modes:
  - 🕕 **New Logic**: 07:00-06:59 (broadcast day)
  - 🕐 **Old Logic**: 00:00-23:59 (calendar day)
- 📈 **Statistics & Analytics** - Processing statistics and data insights
- 📤 **Export & Share** - Generate and share processed Excel files

### iOS-Specific Enhancements
- 🇮🇱 **Hebrew RTL Support** - Native right-to-left layout
- 📱 **iOS Design Patterns** - Native iOS look and feel
- 📁 **Files App Integration** - Pick files from iOS Files app
- 🔗 **Share Sheet Integration** - Native iOS sharing
- 🌙 **Dark Mode Support** - Automatic light/dark theme switching
- ⚡ **Performance Optimized** - Native Dart performance

## 🛠 Technology Stack

### Framework & UI
- **Flutter 3.x** - Cross-platform framework
- **Material Design 3** - Modern UI components
- **Cupertino Widgets** - iOS-style widgets

### Core Libraries
- **excel**: Excel file processing
- **file_picker**: iOS file selection
- **share_plus**: Native iOS sharing
- **path_provider**: File system access
- **intl**: Hebrew date formatting

### State Management
- **Provider** - Simple state management
- **Custom Services** - Business logic separation

## 📂 Project Structure

```
nituvim_ios/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/                   # Data models
│   │   ├── excel_data.dart      # Excel data structures
│   │   └── ...
│   ├── services/                 # Business logic
│   │   ├── excel_processor.dart # Core processing logic
│   │   ├── file_manager.dart    # File operations
│   │   └── ...
│   ├── screens/                  # UI screens
│   │   ├── home_screen.dart     # Main interface
│   │   └── ...
│   ├── widgets/                  # Reusable UI components
│   │   ├── date_range_picker.dart
│   │   ├── progress_indicator.dart
│   │   ├── statistics_view.dart
│   │   └── ...
│   └── utils/
│       ├── constants.dart        # App constants & strings
│       └── ...
├── ios/                          # iOS-specific configuration
│   └── Runner/
│       ├── Info.plist           # iOS permissions & settings
│       └── ...
├── pubspec.yaml                  # Dependencies
└── README.md
```

## ⚙️ Setup Instructions

### Prerequisites

1. **Install Flutter SDK**
   ```bash
   # macOS (using Homebrew)
   brew install --cask flutter
   
   # Or download from: https://flutter.dev/docs/get-started/install
   ```

2. **Install Xcode** (for iOS development)
   - Download from Mac App Store
   - Install Xcode Command Line Tools:
     ```bash
     sudo xcode-select --install
     ```

3. **Verify Installation**
   ```bash
   flutter doctor
   ```

### Project Setup

1. **Clone/Navigate to Project**
   ```bash
   cd nituvim_ios
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **iOS Setup**
   ```bash
   cd ios
   pod install
   cd ..
   ```

4. **Run the App**
   ```bash
   # iOS Simulator
   flutter run
   
   # Physical device (requires developer account)
   flutter run --release
   ```

## 🔧 Development

### Running Tests
```bash
flutter test
```

### Building for Release
```bash
# iOS App Store
flutter build ios --release

# Ad-hoc distribution
flutter build ios --release --flavor production
```

### Code Generation (if needed)
```bash
flutter packages pub run build_runner build
```

## 📱 iOS Configuration

### Permissions (Info.plist)
The app requires these iOS permissions:
- **NSDocumentsFolderUsageDescription** - Access to documents
- **NSDownloadsFolderUsageDescription** - Access to downloads

### File Type Support
- Excel files (`.xlsx`, `.xls`)
- PDF export support
- Files app integration

### Hebrew/RTL Support
- Hebrew localization (`he_IL`)
- RTL layout support
- Hebrew date formatting

## 🔄 Migration Notes

### From Python to Flutter
| Python Component | Flutter Equivalent | Status |
|------------------|-------------------|--------|
| `clean_gui.py` | `home_screen.dart` | ✅ Complete |
| `excel_processor.py` | `excel_processor.dart` | ✅ Complete |
| `config.py` | `constants.dart` | ✅ Complete |
| PySide6 GUI | Flutter widgets | ✅ Complete |
| pandas processing | Dart Excel library | ✅ Complete |
| Outlook integration | iOS Share sheet | ✅ Complete |

### Key Differences
1. **File Access**: iOS document picker vs Windows file dialog
2. **Email**: iOS share sheet vs Outlook COM automation
3. **UI**: Flutter widgets vs Qt/PySide6
4. **Performance**: Native Dart vs Python + Qt

## 🎯 Features Roadmap

### Phase 1: Core Features ✅
- [x] Excel file reading
- [x] Basic date filtering
- [x] Export functionality
- [x] iOS file integration

### Phase 2: Advanced Features 🚧
- [ ] Advanced statistics
- [ ] Chart visualization
- [ ] Batch processing
- [ ] Cloud sync

### Phase 3: Polish & Performance 📅
- [ ] Performance optimization
- [ ] Advanced UI animations
- [ ] Accessibility improvements
- [ ] iPad optimization

## 🐛 Troubleshooting

### Common Issues

1. **CocoaPods Issues**
   ```bash
   cd ios
   pod deintegrate
   pod install
   ```

2. **Build Errors**
   ```bash
   flutter clean
   flutter pub get
   cd ios && pod install && cd ..
   flutter run
   ```

3. **Permission Denied**
   - Check Info.plist permissions
   - Verify app has file access permissions

### Performance Tips
- Use `flutter run --profile` for performance testing
- Monitor memory usage with Xcode Instruments
- Optimize large Excel file processing

## 📝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Original Python desktop application developers
- Flutter team for the amazing framework
- Hebrew localization contributors
- Beta testers and feedback providers

## 📞 Support

For issues and questions:
- Create GitHub issue
- Check existing documentation
- Review troubleshooting guide

---

**Made with ❤️ using Flutter**

*Converting desktop apps to mobile since 2024* 🚀 