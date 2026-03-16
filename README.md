# AutoEase 🚗✨

**AutoEase** is a modern, premium mobile application designed to streamline the vehicle service booking process. Built with Flutter and Material 3, it offers a seamless and visually stunning experience for users to find service centers, book appointments, and manage their vehicle maintenance.

## 📱 Features

### 🔍 Discovery & Booking

- **Interactive Map**: Find nearby service centers with Google Maps integration.
- **Smart Filtering**: Filter service centers by rating, distance, and available services using a glassmorphic bottom sheet.
-**Seamless Booking**: Intuitive flow to select services, choose dates/times, and confirm appointments.

### 📅 Booking Management

-**Dashboard**: View upcoming and past bookings with a rich, staggered list interface.
-**Detailed Views**: Access comprehensive booking details, including status, price breakdown, and service center info.
-**Status Tracking**: Visual timeline and animated badges for booking status (Upcoming, Completed, Cancelled).

### 💬 Communication

-**In-App Chat**: Real-time messaging interface to communicate directly with service centers.
-**Notifications**: Visual indicators for unread messages and online status.

### 👤 User Profile

-**Profile Management**: Edit personal details and manage app settings.
-**Dark Mode**: Fully supported dark theme with high-contrast accessibility.

## 🎨 UI/UX Design

AutoEase implements a premium design system following:
**HCI best practices**:
**Material 3**: Custom theme with dynamic color schemes (Deep Blue & Amber).
**Glassmorphism**: Frosted glass effects on cards, overlays, and navigation elements.
**Micro-Animations**: Smooth transitions, staggered entrances, and tactile feedback using `flutter_animate`.
**Gradient Visuals**: Rich gradient backgrounds and UI elements for depth and vibrancy.

## 🛠️ Tech Stack

**Framework**: [Flutter](https://flutter.dev/) (Dart)
 **State Management**: [Riverpod](https://riverpod.dev/) (Code Generation)
 **Navigation**: [GoRouter](https://pub.dev/packages/go_router)
**Styling**: [Google Fonts](https://pub.dev/packages/google_fonts), Custom Theme Extensions
**Animations**: [flutter_animate](https://pub.dev/packages/flutter_animate)
**Maps**: [google_maps_flutter](https://pub.dev/packages/google_maps_flutter)
**Utilities**: [intl](https://pub.dev/packages/intl), [url_launcher](https://pub.dev/packages/url_launcher)

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (Latest Stable)
- Dart SDK
- Android Studio / VS Code

### Installation

1. **Clone the repository**

    ```bash
    git clone https://github.com/yourusername/auto_ease.git
    cd auto_ease
    ```

2. **Install dependencies**

    ```bash
    flutter pub get
    ```

3. **Run the app**

    ```bash
    flutter run
    ```

## 📂 Project Structure

```lib/
├── src/
│   ├── common/          # Shared widgets, themes, and utils
│   ├── features/        # Feature-based modules (Auth, Booking, Home, Chat, Profile)
│   │   ├── application/ # State management & logic
│   │   ├── data/        # Repositories & mock data
│   │   ├── domain/      # Models & entities
│   │   └── presentation/# UI screens & widgets
│   └── routing/         # App navigation configuration
└── main.dart            # Entry point
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
