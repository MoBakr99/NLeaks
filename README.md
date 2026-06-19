# NLeaks

`NLeaks` is a Flutter mobile application for exploring account, company, user, and leak-related data through a multi-screen UI with authentication, profile management, and dashboard-style reporting.

## Overview

The app is built around a responsive Flutter UI, bloc-based state management, and a Dio API client backed by environment configuration and shared preferences. It supports authentication flows, profile and subscription screens, a home dashboard, leak browsing, and supporting settings pages.

## Key Features

- Email and password login.
- Signup, forgot password, OTP verification, and password reset flows.
- Splash screen and routed navigation across the app.
- Home dashboard with leak overview, charts, filters, and supporting widgets.
- Pages for viewing leaks, leak details, users, settings, profile, and subscription information.
- Persistent local storage through `shared_preferences`.
- API integration through a centralized `Dio` service.
- Responsive layout support through `flutter_screenutil`.
- Themed typography and SVG/image asset support.

## Tech Stack

- Flutter and Dart.
- State management: `flutter_bloc`.
- Networking: `dio`.
- Local persistence: `shared_preferences`.
- Environment config: `flutter_dotenv`.
- Charts: `fl_chart`.
- Fonts and visual styling: `google_fonts`, custom theme files, and SVG/image assets.

## App Structure

### Entry Point

The app starts in [lib/main.dart](lib/main.dart), where it:

- initializes the app environment,
- loads `.env` values,
- initializes shared preferences,
- registers core bloc controllers,
- applies the global theme,
- and launches the splash screen.

### Core Layer

The [lib/core](lib/core) folder contains shared building blocks used across the app:

- `constants/` for routes, colors, fonts, assets, and API endpoints.
- `controllers/` for account and token bloc state.
- `data/` for models and preference helpers.
- `services/` for initialization and network access.
- `themes/` for the global app theme.
- `widgets/` for reusable UI components.

### Feature Modules

The [lib/features](lib/features) folder is organized by user flow:

- `auth/` contains login, signup, forgot password, code verification, and password setup pages.
- `home/` contains the main dashboard, leaks pages, users page, settings page, leak details page, and shared dashboard components.
- `settings/` contains profile and subscription pages.

## Navigation

Defined routes are centralized in [lib/core/constants/app_routes.dart](lib/core/constants/app_routes.dart):

- `/splash`
- `/home`
- `/login`
- `/signup`
- `/forgot-pass`
- `/verify-code`
- `/reset-pass`
- `/profile`
- `/subscription`

## Data and API Layer

The API client in [lib/core/services/api_service.dart](lib/core/services/api_service.dart) uses `BASE_URL` from `.env` and exposes calls for:

- authentication login,
- OTP sending and verification,
- password reset,
- user profile retrieval,
- company information retrieval,
- paginated user listing,
- paginated leak listing.

Relevant backend paths are defined in [lib/core/constants/endpoints.dart](lib/core/constants/endpoints.dart).

## State Management

The app uses bloc controllers for shared state:

- `CorpController` for logged-in account data and current user updates.
- `TokenController` for storing and clearing the active auth token.
- `TimerController` for auth-related timing behavior.

## Assets and Configuration

The project expects the following asset locations:

- `assets/images/pngs/`
- `assets/images/svgs/`

It also loads a local `.env` file for runtime configuration, including the API base URL.

## Requirements

- Flutter SDK compatible with Dart `^3.9.2`.
- Android Studio, Xcode, or another Flutter-supported development environment depending on the target platform.
- A valid `.env` file with the values expected by the app, especially `BASE_URL`.

## Setup

1. Install dependencies.

   ```bash
   flutter pub get
   ```

2. Create or update the `.env` file in the project root.

   ```env
   BASE_URL=https://your-api-base-url.example.com
   ```

3. Run the app.

   ```bash
   flutter run
   ```

## Platform Notes

- Android configuration lives under [android/](android).
- iOS configuration lives under [ios/](ios).
- Web support is available through [web/](web).

## Project Map

- [lib/main.dart](lib/main.dart) - app bootstrap and provider setup.
- [lib/splash_screen.dart](lib/splash_screen.dart) - initial splash experience.
- [lib/core/constants](lib/core/constants) - routes, assets, colors, fonts, and endpoints.
- [lib/core/controllers](lib/core/controllers) - bloc controllers for shared state.
- [lib/core/services](lib/core/services) - initialization and API access.
- [lib/features/auth](lib/features/auth) - authentication flows.
- [lib/features/home](lib/features/home) - dashboard and leak exploration screens.
- [lib/features/settings](lib/features/settings) - profile and subscription screens.

## Development Notes

- The app uses `flutter_screenutil` for consistent sizing across devices.
- Fonts and visual tokens are centralized in the core constants and theme layer.
- Shared preferences are initialized during app startup, so any feature that depends on persisted state should assume `PreferenceManager.init()` has completed.

## Flutter Resources

- [Flutter documentation](https://docs.flutter.dev/)
- [Flutter codelabs](https://docs.flutter.dev/get-started/codelab)
- [Flutter cookbook](https://docs.flutter.dev/cookbook)
