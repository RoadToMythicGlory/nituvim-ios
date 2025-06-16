#!/bin/bash

# Nituvim AI iOS - Setup Script
# Automates Flutter project setup for iOS development

set -e  # Exit on any error

echo "🚀 Nituvim AI iOS - Setup Script"
echo "================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    print_error "This script is designed for macOS. iOS development requires macOS."
    exit 1
fi

print_status "Checking Flutter installation..."

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_warning "Flutter is not installed. Installing via Homebrew..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        print_error "Homebrew is not installed. Please install it first:"
        echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
        exit 1
    fi
    
    brew install --cask flutter
    print_success "Flutter installed via Homebrew"
else
    print_success "Flutter is already installed"
fi

# Check Flutter doctor
print_status "Running Flutter doctor..."
flutter doctor

# Check if Xcode is installed
if ! command -v xcodebuild &> /dev/null; then
    print_warning "Xcode is not installed. Please install it from the Mac App Store."
    print_status "After installing Xcode, run: sudo xcode-select --install"
    exit 1
fi

print_success "Xcode is installed"

# Check if we're in the correct directory
if [ ! -f "pubspec.yaml" ]; then
    print_error "pubspec.yaml not found. Please run this script from the Flutter project root."
    exit 1
fi

print_status "Installing Flutter dependencies..."
flutter pub get
print_success "Flutter dependencies installed"

# Check if iOS directory exists
if [ -d "ios" ]; then
    print_status "Setting up iOS dependencies..."
    cd ios
    
    # Check if CocoaPods is installed
    if ! command -v pod &> /dev/null; then
        print_warning "CocoaPods is not installed. Installing..."
        sudo gem install cocoapods
        print_success "CocoaPods installed"
    fi
    
    # Install iOS dependencies
    pod install
    print_success "iOS dependencies installed"
    
    cd ..
else
    print_error "iOS directory not found. This might not be a Flutter iOS project."
    exit 1
fi

# Run final Flutter doctor check
print_status "Running final Flutter doctor check..."
flutter doctor

# Check for any issues
if flutter doctor | grep -q "✗"; then
    print_warning "There are some issues with Flutter setup. Please review the output above."
else
    print_success "Flutter setup is complete and ready!"
fi

echo ""
echo "🎉 Setup Complete!"
echo "=================="
echo ""
echo "Next steps:"
echo "1. Open iOS Simulator or connect an iPhone"
echo "2. Run: flutter run"
echo "3. Start developing your iOS app!"
echo ""
echo "Useful commands:"
echo "• flutter run              - Run in debug mode"
echo "• flutter run --release    - Run in release mode"
echo "• flutter build ios        - Build for iOS"
echo "• flutter test             - Run tests"
echo "• flutter clean            - Clean build files"
echo ""
print_success "Happy coding! 🚀" 