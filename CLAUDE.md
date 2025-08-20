# Gradeva iOS App

## Project Overview
Gradeva is an iOS application for grading and analytics management, built with SwiftUI and Firebase. It features user authentication, comprehensive onboarding with teacher registration, tabbed navigation, and cloud data storage.

## Technology Stack
- **Platform**: iOS 18.4+
- **Language**: Swift 5.0
- **Framework**: SwiftUI
- **Backend**: Firebase (Auth, Firestore, Core)
- **Authentication**: Sign in with Apple & Google
- **Architecture**: MVVM pattern

## Project Structure
```
Gradeva/
├── GradevaApp.swift           # Main app entry point with Firebase configuration
├── Models/
│   ├── UserModel.swift        # AppUser model with Firebase integration & copy function
│   ├── DatabaseModel.swift    # Firebase database manager singleton
│   ├── RegistrationModel.swift # Registration status and model
│   ├── ExamModel.swift        # Exam and ExamResult models
│   ├── SchoolModel.swift      # School model
│   ├── StudentModel.swift     # Student model
│   └── SubjectModel.swift     # Subject model
├── ViewModels/
│   ├── AuthManager.swift      # Authentication state management
│   ├── NavManager.swift       # Navigation path management
│   ├── RegistrationManager.swift # Teacher registration management
│   └── SubjectsManager.swift  # Subjects and onboarding management
├── Views/
│   ├── MainView.swift         # Main content view with tab navigation
│   ├── HomeView.swift         # Home tab view
│   ├── SignInView.swift       # Authentication view with Apple & Google Sign-In
│   ├── SettingsView.swift     # Settings view
│   ├── Analytics/
│   │   └── AnalyticsView.swift
│   ├── Components/
│   │   └── ErrorAlertView.swift # Reusable error alert component
│   ├── Grading/
│   │   ├── Components/
│   │   │   ├── GradingCard.swift    # Individual grading card component
│   │   │   └── GradingSubject.swift # Subject selection component
│   │   ├── GradingView.swift        # Main grading interface
│   │   └── GradingExamView.swift    # Exam grading view
│   ├── Onboarding/
│   │   ├── Components/
│   │   │   ├── NameStepView.swift      # Name input step
│   │   │   ├── WelcomeStepView.swift   # Welcome step
│   │   │   ├── SubjectsStepView.swift  # Subject selection step
│   │   │   └── SubjectSelection.swift  # Subject selection component
│   │   ├── WelcomeView.swift      # Multi-step onboarding flow
│   │   └── NotRegisteredView.swift # View for unregistered teachers
│   └── Profile/
│       └── ProfileView.swift
├── Services/
│   ├── UserServices.swift      # User data operations with Firestore
│   ├── AppleSignInService.swift # Apple authentication service
│   ├── GoogleSignInService.swift # Google authentication service
│   ├── RegistrationService.swift # User registration logic
│   └── SubjectServices.swift   # Subject data operations
├── Utils/
│   ├── AuthError.swift         # Authentication error handling
│   └── CryptoUtils.swift       # Cryptographic utilities
├── Assets.xcassets/           # App icons and color assets (includes Google 'g' icon)
├── GoogleService-Info.plist   # Firebase configuration
└── Gradeva.entitlements       # App capabilities and entitlements
```

## Key Features
- **Authentication**: Sign in with Apple & Google integration
- **Teacher Registration**: Registration link system for school administrators
- **Comprehensive Onboarding**: Multi-step process (welcome, name, subject selection)
- **Tab Navigation**: Home, Grading, Analytics, Profile
- **Subject Management**: Teachers can claim and manage subjects within schools
- **Firebase Integration**: Firestore database, Authentication
- **User Management**: Registration status tracking with reactive state management
- **Navigation**: Programmatic navigation with NavManager

## Development Workflow

### Building the App
```bash
# Open project in Xcode
open Gradeva.xcodeproj

# Build from command line
xcodebuild -project Gradeva.xcodeproj -scheme Gradeva -destination 'platform=iOS Simulator,name=iPhone 15' build
```

### Dependencies
All dependencies are managed through Swift Package Manager:
- Firebase iOS SDK (v12.1.0)
- FirebaseAuth, FirebaseCore, FirebaseFirestore

### Firebase Setup
- The app uses Firebase for authentication and data storage
- GoogleService-Info.plist contains Firebase configuration
- Database manager is implemented as a singleton in DatabaseModel.swift

### Authentication & Onboarding Flow
1. App checks for existing Firebase auth state
2. If not authenticated, shows SignInView with Apple & Google Sign-In options
3. Upon successful authentication:
   - If user has no school registration: shows NotRegisteredView with registration link
   - If user needs onboarding: shows multi-step WelcomeView (welcome → name → subjects)
   - If user is fully set up: shows main TabView interface
4. AuthManager handles state changes and user session management
5. RegistrationManager handles teacher registration status
6. SubjectsManager manages subject selection and onboarding completion
7. Dedicated services handle Apple and Google authentication flows

### Testing
- No test framework currently configured
- Testing should be added for ViewModels and Services

### Code Style
- SwiftUI declarative UI
- MVVM architecture pattern
- ObservableObject for state management
- Async/await for asynchronous operations
- **Immutable Data Patterns**: Never mutate class instances directly - use copy functions instead
  - Example: `let updatedUser = currentUser.copy(displayName: newName)` instead of `currentUser.displayName = newName`
  - All model classes implement copy functions for creating modified instances
  - This ensures data integrity and prevents unintended side effects

## Development Commands

### Xcode Operations
```bash
# Clean build folder
xcodebuild clean -project Gradeva.xcodeproj

# Archive for distribution
xcodebuild archive -project Gradeva.xcodeproj -scheme Gradeva -archivePath build/Gradeva.xcarchive

# Run on simulator
xcodebuild -project Gradeva.xcodeproj -scheme Gradeva -destination 'platform=iOS Simulator,name=iPhone 15' -allowProvisioningUpdates
```

### Package Management
```bash
# Package dependencies are resolved automatically by Xcode
# Check Package.resolved for current dependency versions
```

## Configuration
- **Minimum iOS Version**: 18.4
- **Marketing Version**: 1.0
- **Bundle Identifier**: Configured in project settings
- **Firebase**: Configured via GoogleService-Info.plist

## Security Considerations
- Sign in with Apple provides privacy-focused authentication
- Google Sign-In offers additional authentication options
- Firebase handles secure user authentication and data storage
- App entitlements configured for Sign in with Apple capability
- CryptoUtils provides secure cryptographic operations
- AuthError handles authentication failures gracefully
- Registration link system ensures only authorized teachers can access schools
- Immutable data patterns prevent accidental state mutations and improve security

## Future Enhancements
- Add comprehensive test suite (XCTest framework recommended)
- Implement CI/CD pipeline
- Add documentation generation
- Consider adding SwiftLint for code style enforcement