# Project Structure & Organization

## Root Directory Layout
```
├── lib/                    # Main Dart source code
├── assets/                 # Static assets (images, icons)
├── web/                    # Web-specific files and entry point
├── android/                # Android platform configuration
├── ios/                    # iOS platform configuration
├── build/                  # Generated build artifacts
├── .dart_tool/             # Dart tooling cache
├── pubspec.yaml            # Dependencies and project config
├── firebase.json           # Firebase hosting configuration
└── analysis_options.yaml  # Dart/Flutter linting rules
```

## Core Architecture Pattern
**BLoC (Business Logic Component) Pattern** with Repository Pattern for data layer separation.

## lib/ Directory Structure

### State Management (`lib/blocs/` & `lib/cubit/`)
- **BLoCs**: Business logic for complex state management
  - `auth/` - Authentication state
  - `assignment/`, `classroom/`, `student/` - Core domain entities
  - `mcq/`, `msq/`, `nat/`, `subjective/` - Question type handlers
  - `chat_agent/`, `rag_agent/` - AI agent interactions
- **Cubits**: Simple state management for forms and UI state

### Data Layer (`lib/repositories/`)
- Repository pattern for data access abstraction
- Separate repositories for each domain entity
- `ai/` subdirectory for AI-specific repositories
- Each repository handles API calls and data transformation

### Models (`lib/models/`)
- Data models representing domain entities
- `questions/` subdirectory for question-specific models
- `extended/` for enhanced model variants

### UI Layer (`lib/pages/`)
- Page-based organization matching app navigation
- Each major feature has its own page directory
- Pages consume BLoCs/Cubits for state management

### Services (`lib/services/`)
- External service integrations (auth, PDF generation, etc.)
- Utility services for cross-cutting concerns

### Common Components (`lib/common/`)
- Reusable widgets and utilities
- Global providers and shared UI components

### Configuration (`lib/constants/`)
- App-wide constants and configuration
- Dummy data for development/testing

### Navigation (`lib/router/`)
- Centralized routing configuration using go_router
- Route definitions and navigation logic

### Serialization (`lib/serializers/`)
- JSON serialization/deserialization logic
- Organized by feature area (agents, etc.)

## Naming Conventions
- **Files**: snake_case (e.g., `question_bank_repository.dart`)
- **Classes**: PascalCase (e.g., `QuestionBankRepository`)
- **Variables/Functions**: camelCase (e.g., `questionBankRepository`)
- **Constants**: SCREAMING_SNAKE_CASE (e.g., `APP_NAME`)

## Import Organization
- Central `lib.dart` file exports commonly used dependencies
- Reduces import boilerplate across the application
- Groups exports by category (services, repositories, blocs, etc.)

## Responsive Design
- Uses `responsive_framework` with defined breakpoints:
  - MOBILE: 0-450px
  - TABLET: 451-800px  
  - DESKTOP: 801-1920px

## Asset Management
- Static assets in `assets/` directory
- Declared in `pubspec.yaml` under `flutter.assets`
- Includes SVG icons and PNG images for branding