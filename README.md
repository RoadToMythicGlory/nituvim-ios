# Nituvim AI - iOS App

> Professional Excel data processing application for iOS

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![iOS](https://img.shields.io/badge/iOS-12.0+-000000?logo=apple)](https://developer.apple.com/ios/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

## Overview

Nituvim AI is a Flutter-based iOS application that brings advanced Excel data processing capabilities to mobile devices. Originally developed as a Python desktop application, this iOS version maintains all core functionality while providing a native mobile experience with Hebrew RTL support.

## Features

### Core Functionality
- **Excel File Processing**: Read and analyze .xlsx and .xls files
- **Advanced Date Filtering**: Two filtering modes for different use cases
  - Broadcast Day Logic: 07:00-06:59 (for media/broadcasting)
  - Calendar Day Logic: 00:00-23:59 (standard business hours)
- **Data Analytics**: Generate statistics and insights from processed data
- **Export & Sharing**: Create reports and share via iOS native sharing

### iOS Integration
- **Files App Support**: Import Excel files directly from iOS Files app
- **Native Sharing**: Export and share results using iOS Share Sheet
- **Hebrew RTL Support**: Full right-to-left layout and text support
- **Dark Mode**: Automatic light/dark theme switching
- **iOS Design**: Native iOS look and feel with Cupertino widgets

## Technology Stack

### Framework
- **Flutter 3.x**: Cross-platform mobile framework
- **Dart**: Programming language optimized for mobile development

### Key Dependencies
- `excel`: Excel file processing and manipulation
- `file_picker`: iOS file selection integration
- `share_plus`: Native iOS sharing capabilities
- `intl`: Internationalization and Hebrew localization
- `provider`: State management

### Architecture
- **MVVM Pattern**: Clean separation of concerns
- **Service Layer**: Business logic isolation
- **Custom Widgets**: Reusable UI components optimized for Hebrew text

## Getting Started

### Prerequisites
- Flutter SDK 3.x
- Xcode 14+ (for iOS development)
- iOS 12.0+ target device

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/RoadToMythicGlory/nituvim-ios.git
   cd nituvim-ios
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   cd ios && pod install && cd ..
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Setup Scripts
For automated environment setup:
- **macOS/Linux**: `./setup.sh`
- **Windows**: `setup_windows.bat`

## Usage

1. **Import File**: Tap the import button to select an Excel file from the iOS Files app
2. **Configure Processing**: Choose the appropriate date filtering mode
3. **Process Data**: Review real-time processing progress and statistics
4. **Export Results**: Share or save the processed data using iOS sharing options

## Project Structure

```
lib/
├── main.dart                 # Application entry point
├── models/                   # Data models
├── services/                 # Business logic
│   ├── excel_processor.dart  # Core Excel processing
│   └── file_manager.dart     # File I/O operations
├── screens/                  # UI screens
├── widgets/                  # Reusable components
└── utils/                    # Constants and helpers
```

## Development

### Running Tests
```bash
flutter test
```

### Building for Release
```bash
flutter build ios --release
```

### Code Quality
- Follow Flutter/Dart style guidelines
- Maintain test coverage for new features
- Ensure Hebrew RTL compatibility

## Deployment

### iOS App Store
1. Configure code signing in Xcode
2. Build release version: `flutter build ios --release`
3. Submit through App Store Connect

### CI/CD
Automated pipeline configured with Codemagic for:
- Testing and validation
- iOS build generation
- Code signing and deployment

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-feature`)
3. Commit your changes (`git commit -m 'Add new feature'`)
4. Push to the branch (`git push origin feature/new-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- **Issues**: [GitHub Issues](https://github.com/RoadToMythicGlory/nituvim-ios/issues)
- **Documentation**: Check the project wiki for detailed guides

## Acknowledgments

- Original Python desktop application developers
- Flutter community for excellent packages and support
- Hebrew localization contributors

---

*Built with Flutter for the iOS ecosystem* 