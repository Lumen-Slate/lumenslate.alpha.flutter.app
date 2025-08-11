# Technology Stack & Build System

## Framework & Language
- **Flutter Web**: Cross-platform UI framework using Dart
- **Dart SDK**: ^3.8.1
- **Target Platform**: Web (Chrome-first development)

## Key Dependencies

### State Management
- **flutter_bloc**: ^9.1.1 - BLoC pattern for state management
- **equatable**: ^2.0.7 - Value equality for Dart objects

### UI & Responsive Design
- **responsive_framework**: ^1.5.1 - Responsive breakpoints and layouts
- **google_fonts**: ^6.3.0 - Typography
- **auto_size_text**: ^3.0.0 - Adaptive text sizing
- **flutter_expandable_fab**: ^2.5.2 - Expandable floating action buttons

### Navigation & Routing
- **go_router**: ^16.1.0 - Declarative routing

### Backend Integration
- **dio**: ^5.8.0+1 - HTTP client for API calls
- **firebase_core**: ^3.15.2 - Firebase integration
- **firebase_auth**: ^5.7.0 - Authentication
- **google_sign_in**: ^6.3.0 - Google OAuth

### Utilities
- **logger**: ^2.6.1 - Logging
- **uuid**: ^4.5.1 - Unique identifier generation
- **intl**: ^0.20.2 - Internationalization
- **url_launcher**: ^6.3.2 - External URL handling

## Development Tools
- **flutter_lints**: ^6.0.0 - Dart/Flutter linting rules
- **analysis_options.yaml**: Standard Flutter linting configuration

## Common Commands

### Development
```bash
# Install dependencies
flutter pub get

# Run in development (Chrome)
flutter run -d chrome

# Hot reload is available during development
```

### Build & Deploy
```bash
# Build for production
flutter build web

# Deploy to Firebase Hosting
firebase deploy --only hosting
```

### Code Quality
```bash
# Run static analysis
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

## Firebase Configuration
- **Project ID**: lumen-slate
- **Hosting**: build/web directory
- **Multi-platform**: Android, iOS, Web support configured
- **SPA Routing**: All routes redirect to index.html