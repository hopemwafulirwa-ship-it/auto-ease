# Story 1.1: User Onboarding, Multi-Role Registration & Supabase Auth Integration

Status: done

## Story

As a new user,  
I want to register an account using email/password or phone and select my role (Customer or Mechanic/Service Provider),  
so that I can securely authenticate, persist my session, and access role-specific application features.

## Acceptance Criteria

1. **Given** an unauthenticated user on the onboarding/registration screen,  
   **When** they enter valid credentials, select a role (Customer or Mechanic/Service Center), and submit,  
   **Then** an account is created in Supabase Auth, a corresponding record is inserted into the `profiles` table with role metadata, and the user is redirected to the home screen.
2. **Given** an authenticated user or returning user,  
   **When** the app launches,  
   **Then** session tokens in secure storage/Supabase session are checked with automatic background JWT token refresh before expiration, redirecting to the home screen if authenticated or onboarding if unauthenticated.
3. **Given** an invalid input during registration/login (e.g. invalid email format, short password, network error),  
   **When** submission is attempted,  
   **Then** clear user-friendly error indicators and UI feedback are displayed without crashing the app.

## Tasks / Subtasks

- [x] Task 1: Domain & Model Setup (AC: 1, 2)
  - [x] Define `UserProfile` entity and `UserRole` enum (`customer`, `mechanic`) in `lib/src/features/auth/domain/app_user.dart` and `lib/src/features/profile/domain/user_profile.dart`.
  - [x] Implement JSON serialization / Supabase mapping for `AppUser` and `UserProfile`.
- [x] Task 2: Supabase Auth Repository (AC: 1, 2, 3)
  - [x] Create `AuthRepository` interface and Supabase implementation in `lib/src/features/auth/data/auth_repository.dart`.
  - [x] Implement `signUpWithEmailAndPassword({required String email, required String password, String? name, AppUserRole role})`.
  - [x] Implement `signInWithEmailAndPassword(String email, String password)`.
  - [x] Implement `signOut()` and `authStateChanges()`.
- [x] Task 3: Riverpod Auth State Management (AC: 1, 2, 3)
  - [x] Implement `authControllerProvider` in `lib/src/features/auth/application/auth_controller.dart`.
  - [x] Handle async state (`AsyncValue`), loading indicators, and error catching.
- [x] Task 4: UI Onboarding & Auth Screens (AC: 1, 3)
  - [x] Create `OnboardingScreen` in `lib/src/features/onboarding/presentation/onboarding_screen.dart`.
  - [x] Create `LoginScreen` and `RegisterScreen` with role toggle selector in `lib/src/features/auth/presentation/`.
  - [x] Connect form validators and submit handlers to `authControllerProvider`.
- [x] Task 5: Routing & Session Guarding (AC: 1, 2)
  - [x] Update `lib/src/routing/app_router.dart` to listen to auth state changes and guard protected routes (`/home` and `/mechanic/home` vs `/login`/`/onboarding`).
- [x] Task 6: Unit & BDD Widget Tests (AC: 1, 2, 3)
  - [x] Add unit tests for `AuthRepository` and `AuthController`.
  - [x] Add widget tests for `RegisterScreen` role selection and form validation.

## Dev Notes

- **Architecture:** Feature-first structure under `lib/src/features/auth` (data, domain, presentation, application).
- **State Management:** Riverpod 2.x (`flutter_riverpod`, `riverpod_annotation`). Use `AsyncNotifier` or `Notifier` with `riverpod_generator`.
- **Backend:** `supabase_flutter` 2.8.0.
  - `Supabase.instance.client.auth.signUp(email: ..., password: ..., data: {'role': role.name})`
  - Ensure `profiles` table schema in Supabase accepts `id` (references `auth.users`), `email`, `role`, and `created_at`.
- **Router:** `go_router` 13.x with `refreshListenable` or stream-based `redirect` re-evaluation based on Supabase `onAuthStateChange`.

### Project Structure Notes

- Alignment with `lib/src/features/auth/` and `lib/src/routing/app_router.dart`.
- Uses existing `lib/src/common/supabase_config.dart` and `AppTheme`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 1: User Authentication & Vehicle Profile Management]
- [Source: pubspec.yaml]

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash

### Debug Log References

### Completion Notes List

- Story 1.1 spec created and validated against checklist.
- Sprint status updated to `ready-for-dev`.

### File List

- `_bmad-output/implementation-artifacts/1-1-user-onboarding-multi-role-registration-supabase-auth-integration.md`
- `_bmad-output/implementation-artifacts/sprint-status.yaml`
