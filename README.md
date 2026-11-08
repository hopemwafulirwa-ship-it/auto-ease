# AutoEase

AutoEase is an enterprise-grade mobile application built with Flutter, designed to connect vehicle owners with automotive service centers and qualified mechanics. The platform streamlines service discovery, appointment scheduling, real-time service tracking, and customer-provider communication within an intuitive Material 3 interface.

---

## Core Capabilities

### Service Discovery and Location Intelligence
- **Interactive Mapping**: Proximity-based discovery powered by Google Maps and device geolocation.
- **Parametric Filtering**: Filter service providers by distance, customer rating, available service categories, and operational status.
- **Provider Profiles**: Comprehensive service center listings with operating hours, technician specializations, facility details, and pricing schedules.

### Booking and Appointment Management
- **End-to-End Scheduling**: Streamlined booking flow covering service selection, appointment scheduling, vehicle specification input, and booking confirmation.
- **Lifecycle Tracking**: Real-time status progression covering pending, scheduled, in-progress, completed, and cancelled states.
- **Detailed Invoicing & Receipts**: Transparent breakdowns of labor, parts, estimated durations, and payment summaries.

### Service Tracking and Monitoring
- **Live Progress Updates**: Visual status tracking showing real-time updates as vehicles progress through intake, inspection, repair, and handover.
- **Technician Attribution**: Direct visibility into assigned mechanics and service bays.

### Communication and Reviews
- **Direct Messaging**: Dedicated messaging channels enabling clear dialogue between customers and service providers.
- **Ratings and Feedback**: Verified customer review system with structured ratings, written feedback, and historical performance tracking.

### User Account and Preferences
- **Authentication**: Secure user authentication and session management powered by Supabase.
- **Vehicle Profiles**: Centralized management of user vehicles, service histories, and maintenance schedules.
- **Adaptive Theming**: Full support for system, light, and dark display modes with high-contrast accessibility compliance.

---

## Architecture and Design Principles

The application adheres to clean architecture principles and a **Feature-First** structure. Code is decoupled across distinct layers within each feature domain:

```
lib/
├── src/
│   ├── common/                  # Shared design tokens, base widgets, and configurations
│   │   ├── supabase_config.dart # Backend configuration
│   │   ├── theme/               # Material 3 palettes, typography, and styling
│   │   └── widgets/             # Reusable enterprise UI components
│   ├── features/                # Domain-driven feature packages
│   │   ├── auth/                # Authentication, registration, and session logic
│   │   ├── booking/             # Scheduling, appointments, and service orders
│   │   ├── chat/                # Real-time messaging and notifications
│   │   ├── home/                # Discovery feed and summary dashboards
│   │   ├── mechanic/            # Service center and technician domain data
│   │   ├── onboarding/          # First-run experience and user introduction
│   │   ├── profile/             # Account management, user preferences, and vehicle logs
│   │   ├── reviews/             # Customer feedback and rating interfaces
│   │   └── tracking/            # Real-time service progress monitoring
│   └── routing/                 # Declarative application routing (GoRouter)
└── main.dart                    # Application entry point and service bootstrap
```

### Architectural Layers
- **Domain Layer**: Pure Dart entities, value objects, and business contracts independent of frameworks.
- **Data Layer**: Data transfer objects (DTOs), remote service adapters, local storage, and repository implementations.
- **Application Layer**: Business logic, workflow orchestration, and cross-cutting service coordination.
- **Presentation Layer**: Riverpod state controllers and UI widgets responding to reactive state changes.

---

## Technical Stack

| Layer | Technology | Details |
| :--- | :--- | :--- |
| **Framework** | Flutter (Dart SDK `>=3.2.0 <4.0.0`) | Cross-platform mobile foundation targeting Android and iOS |
| **State Management** | Flutter Riverpod (`^2.5.1`) | Compile-time safe, unidirectional reactive state with code generation |
| **Backend & Auth** | Supabase (`supabase_flutter ^2.8.0`) | Relational database, authentication, and real-time data sync |
| **Navigation** | GoRouter (`^13.1.0`) | Declarative, URL-driven navigation supporting deep linking |
| **Geospatial & Maps** | Google Maps Flutter, Geolocator | Location services, map rendering, and distance computations |
| **Design System** | Material 3, Google Fonts | Consistent design system with responsive layouts and fluid motion |
| **Quality & Testing** | Flutter Test, BDD Widget Test | Unit, widget, and behavior-driven integration testing |

---

## Development Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, version 3.2.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (included with Flutter)
- Android Studio / Xcode configured with platform emulators or connected physical devices
- Active Google Maps API key (with Android and iOS SDKs enabled)
- Supabase project credentials

### Local Environment Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/auto-ease.git
   cd auto-ease
   ```

2. **Retrieve dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate code artifacts**:
   Execute the code generator to build Riverpod providers, serialization schemas, and route manifests:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Configure environment keys**:
   - Ensure backend credentials in `lib/src/common/supabase_config.dart` point to your target Supabase instance.
   - Set up platform-specific Google Maps API keys:
     - Android: `android/app/src/main/AndroidManifest.xml`
     - iOS: `ios/Runner/AppDelegate.swift`

5. **Execute the application**:
   ```bash
   flutter run
   ```

---

## Testing and Quality Assurance

Maintain code health and compliance with project quality standards through the following toolchains:

### Static Analysis
Run static analysis to verify compliance with analysis options and Riverpod lint rules:
```bash
flutter analyze
```

### Automated Testing
Execute the complete test suite including unit, widget, and behavioral specs:
```bash
flutter test
```

### Continuous Code Generation
Watch for source code changes during development:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

---

## Contributing

1. Create a feature branch from `main` (`git checkout -b feature/feature-name`).
2. Adhere to repository linting rules and verify with `flutter analyze`.
3. Ensure all existing and newly authored tests pass via `flutter test`.
4. Commit changes with clear, imperative commit messages following conventional commits standard.
5. Submit a Pull Request detailing the changes and relevant context.

---

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for further details.
