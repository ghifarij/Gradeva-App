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
│   ├── SubjectModel.swift     # Subject model
│   └── BatchModel.swift       # Batch model for student grouping
├── ViewModels/
│   ├── AuthManager.swift      # Authentication state management
│   ├── NavManager.swift       # Navigation path management
│   ├── RegistrationManager.swift # Teacher registration management
│   ├── SubjectsManager.swift  # Subjects and onboarding management
│   ├── BatchManager.swift     # Batch management
│   ├── ExamsManager.swift     # Exam management
│   ├── ExamResultsManager.swift # Exam results management
│   ├── StudentsManager.swift  # Student management
│   ├── SchoolManager.swift    # School management
│   ├── ProfileViewModel.swift # Profile view logic
│   └── HeaderCardViewModel.swift # Header card component logic
├── Views/
│   ├── MainView.swift         # Main content view with navigation and state
│   ├── MainTabView.swift      # Tab navigation container
│   ├── SignInView.swift       # Authentication view with Apple & Google Sign-In
│   ├── SplashScreenView.swift # Initial splash screen
│   ├── FirstLaunchWelcomeView.swift # First app launch welcome
│   ├── Analytics/
│   │   └── AnalyticsView.swift
│   ├── Components/
│   │   ├── ErrorAlertView.swift # Reusable error alert component
│   │   └── DynamicHStack.swift  # Dynamic horizontal stack component
│   ├── Grading/
│   │   ├── Components/
│   │   │   ├── GradingCard.swift    # Individual grading card component
│   │   │   ├── ExamCard.swift       # Exam card component
│   │   │   └── StudentCard.swift    # Student card component
│   │   ├── GradingView.swift        # Main grading interface
│   │   ├── ExamListView.swift       # List of exams for grading
│   │   ├── StudentGradingListView.swift # Student grading interface
│   │   └── SetAssessmentView.swift  # Assessment creation
│   ├── Home/
│   │   ├── Components/
│   │   │   ├── HeaderCardView.swift      # Dashboard header card
│   │   │   ├── InfoCardView.swift        # Information cards
│   │   │   ├── ProfileAvatarView.swift   # Profile avatar display
│   │   │   ├── BatchInfoView.swift       # Batch information display
│   │   │   ├── PendingGradesView.swift   # Pending grades overview
│   │   │   ├── SubjectNavigationView.swift # Subject navigation
│   │   │   └── SummaryView.swift         # Summary statistics
│   │   └── HomeView.swift               # Home dashboard
│   ├── Onboarding/
│   │   ├── Components/
│   │   │   ├── NameStepView.swift       # Name input step
│   │   │   ├── WelcomeStepView.swift    # Welcome step
│   │   │   ├── SubjectsStepView.swift   # Subject selection step
│   │   │   ├── SubjectSelection.swift   # Subject selection component
│   │   │   └── RegistrationStepView.swift # Registration step
│   │   ├── WelcomeView.swift      # Multi-step onboarding flow
│   │   └── NotRegisteredView.swift # View for unregistered teachers
│   └── Profile/
│       ├── ProfileView.swift    # Main profile view
│       └── Components/
│           ├── ProfileHeaderView.swift    # Profile header section
│           ├── ProfileInfoSectionView.swift # Personal info section
│           ├── SchoolInfoSectionView.swift  # School information
│           ├── SubjectsSectionView.swift    # Subjects display
│           ├── AvatarSelectionView.swift    # Avatar selection
│           └── SignOutSectionView.swift     # Sign out section
├── Services/
│   ├── UserServices.swift      # User data operations with Firestore
│   ├── AppleSignInService.swift # Apple authentication service
│   ├── GoogleSignInService.swift # Google authentication service
│   ├── RegistrationService.swift # User registration logic
│   ├── SubjectServices.swift   # Subject data operations
│   ├── SchoolServices.swift    # School data operations
│   ├── BatchServices.swift     # Batch data operations
│   ├── StudentServices.swift   # Student data operations
│   ├── ExamServices.swift      # Exam data operations
│   └── ExamResultServices.swift # Exam result operations
├── Utils/
│   ├── AuthError.swift         # Authentication error handling
│   ├── CryptoUtils.swift       # Cryptographic utilities
│   └── AppLaunchManager.swift  # App launch state management
├── Assets.xcassets/           # App icons, color assets, and avatar images
├── GoogleService-Info.plist   # Firebase configuration
├── Info.plist                 # App configuration and URL schemes
├── Gradeva.entitlements       # App capabilities (Sign in with Apple)
└── firestore.rules            # Firestore security rules
```

## Key Features
- **Authentication**: Sign in with Apple & Google integration with comprehensive error handling
- **Teacher Registration**: Registration link system for school administrators
- **Comprehensive Onboarding**: Multi-step process (welcome, name, subject selection)
- **Tab Navigation**: Home, Grading (Analytics temporarily disabled)
- **Subject Management**: Teachers can claim and manage subjects within schools
- **Student & Batch Management**: Complete student organization with batch grouping
- **Exam System**: Full exam creation, grading, and results tracking
- **Profile Management**: User profiles with avatar selection and school information
- **Firebase Integration**: Firestore database, Authentication with real-time listeners
- **User Management**: Registration status tracking with reactive state management
- **Navigation**: Programmatic navigation with NavManager and deep linking
- **App Lifecycle**: First launch detection and splash screen management
- **Accessibility**: Full VoiceOver support and comprehensive accessibility features

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
- **Firebase iOS SDK (v12.1.0)**: Core Firebase functionality
- **GoogleSignIn-iOS (v9.0.0)**: Google authentication
- **AppAuth-iOS (v2.0.0)**: OAuth authentication flows
- **Supporting Libraries**: GoogleUtilities, GoogleDataTransport, Swift Protobuf, and related Firebase dependencies

### Firebase Setup
- The app uses Firebase for authentication and data storage
- GoogleService-Info.plist contains Firebase configuration
- Database manager is implemented as a singleton in DatabaseModel.swift

### Authentication & Onboarding Flow
1. **App Launch**: Shows splash screen, then checks if first launch
2. **First Launch**: Shows FirstLaunchWelcomeView with login prompt
3. **Authentication Check**: Checks for existing Firebase auth state
4. **Sign-In Process**: If not authenticated, shows SignInView with Apple & Google Sign-In options
5. **Post-Authentication Logic**:
   - If user has no school registration: shows NotRegisteredView with registration link
   - If user needs onboarding: shows multi-step WelcomeView (welcome → name → subjects)
   - If user is fully set up: shows MainTabView interface
6. **State Management**: AuthManager handles auth state, real-time user data listeners
7. **Registration**: RegistrationManager handles teacher registration status
8. **Onboarding**: SubjectsManager manages subject selection and onboarding completion
9. **Services**: Dedicated Apple and Google authentication services with error handling

### Testing
- No test framework currently configured
- Testing should be added for ViewModels and Services

### Code Style
- **SwiftUI**: Declarative UI with modern SwiftUI patterns
- **MVVM Architecture**: Clear separation of concerns with ViewModels
- **ObservableObject**: Reactive state management with @Published properties
- **Async/await**: Modern asynchronous programming patterns
- **Singleton Pattern**: Shared managers (AuthManager.shared, NavManager.shared)
- **Real-time Listeners**: Firebase Firestore listeners for live data updates
- **Immutable Data Patterns**: Never mutate class instances directly - use copy functions instead
  - Example: `let updatedUser = currentUser.copy(displayName: newName)` instead of `currentUser.displayName = newName`
  - All model classes implement copy functions for creating modified instances
  - This ensures data integrity and prevents unintended side effects
- **Error Handling**: Comprehensive error handling with AuthError enum and user feedback
- **Navigation**: Programmatic navigation using NavigationStack and NavManager
- **Accessibility Requirements**: All UI components must include comprehensive accessibility features
  - Use proper `accessibilityLabel` for element identification
  - Use `accessibilityValue` for dynamic states/content (e.g., "Step 2 of 3", "Selected")
  - Use `accessibilityHint` with "Double tap to..." for actionable elements
  - Use `accessibilityAddTraits` to identify element types (.isButton, .isHeader, .isStaticText)
  - Use `accessibilityElement(children: .combine)` with label-value pattern for grouped content
  - Hide decorative elements with `accessibilityHidden(true)`
  - Provide loading state feedback for VoiceOver users
  - Use consistent accessibility patterns across components

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
- **URL Schemes**: Google OAuth configured in Info.plist
- **Entitlements**: Sign in with Apple capability enabled
- **Assets**: Custom color scheme, avatar images (9 available), app icons

## Security Considerations
- **Sign in with Apple**: Privacy-focused authentication with minimal data exposure
- **Google Sign-In**: Secure OAuth 2.0 flow with proper credential handling
- **Firebase Security**: Secure user authentication and data storage with Firestore rules
- **App Entitlements**: Sign in with Apple capability properly configured
- **Cryptographic Operations**: CryptoUtils provides secure operations
- **Error Handling**: AuthError handles authentication failures gracefully without exposing sensitive info
- **Registration System**: Link-based registration ensures only authorized teachers access schools
- **Immutable Data**: Copy patterns prevent accidental state mutations and improve security
- **Real-time Security**: Firestore listeners with proper authentication checks
- **Lifecycle Management**: Proper cleanup of listeners and resources on sign-out

## Accessibility Standards
The app fully complies with iOS accessibility guidelines and WCAG standards:
- **VoiceOver Support**: Complete screen reader navigation with descriptive labels and hints
- **Dynamic Type**: All text scales appropriately with user font size preferences
- **Touch Targets**: All interactive elements meet 44pt minimum touch target size
- **Keyboard Navigation**: Full keyboard accessibility for external keyboards
- **Reduced Motion**: Respects user's reduced motion preferences
- **High Contrast**: Compatible with high contrast display settings
- **Motor Accessibility**: Accommodates users with motor impairments through proper button sizing and clear interaction patterns
- **Cognitive Accessibility**: Clear navigation flows, consistent patterns, and helpful error messages

## Future Enhancements
- Add comprehensive test suite (XCTest framework recommended)
- Implement CI/CD pipeline
- Add documentation generation
- Consider adding SwiftLint for code style enforcement