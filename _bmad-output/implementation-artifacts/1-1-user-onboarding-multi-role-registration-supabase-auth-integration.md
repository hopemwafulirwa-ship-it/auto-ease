# Story 1.1: User Onboarding, Multi-Role Registration & Supabase Auth Integration

Status: done

## Story

As a new user,  
I want to register an account using email and password and select my role (`Customer` or `Mechanic`),  
so that I can securely authenticate, persist my session, and access role-specific application features.

## Acceptance Criteria

1. **Given** an unauthenticated user on the registration screen,  
   **When** the user enters valid credentials (full name, valid email address, password of at least 6 characters, and matching confirmation password), selects a role (`Customer` or `Mechanic`), and submits the form,  
   **Then** the app creates an account in Supabase Auth with role and name metadata, persists a corresponding record in the `profiles` table (`id`, `email`, `name`, `full_name`, `role`), and redirects the user to `/home` (`AppUserRole.customer`) or `/mechanic/home` (`AppUserRole.mechanic`) when an active session is established (or prompts for email confirmation if `AuthResponse.session == null`).
2. **Given** a returning user,  
   **When** the app launches or auth state changes,  
   **Then** the app checks the persisted Supabase session in secure storage, automatically refreshes the JWT in the background before expiration, and redirects the user to their role-specific home screen (`/home` or `/mechanic/home`) if authenticated, to `/onboarding` on first launch if unauthenticated, or to `/login` on subsequent unauthenticated launches, sign-out (`signOut()`), or unrecoverable token refresh failure.
3. **Given** invalid input during registration or login (such as an empty name, an invalid email format, a password shorter than 6 characters, mismatched passwords, or a network/authentication error),  
   **When** the user submits the form,  
   **Then** the app displays clear, user-friendly error messages without crashing.

## Dev Notes

- **Architecture:** Feature-first structure under `lib/src/features/auth` (`data`, `domain`, `presentation`, `application`), aligned with `lib/src/routing/app_router.dart` and using existing `lib/src/common/supabase_config.dart`, `lib/src/common/supabase_client_provider.dart`, and `AppTheme`.
- **State Management:** Riverpod 2.x (`flutter_riverpod`, `riverpod_annotation`) using `AsyncNotifier` (`_$AuthController`) with `riverpod_generator` and `AsyncValue.guard`.
- **Backend (`supabase_flutter` 2.8.0):**
  - Inject `SupabaseClient` via `supabaseClientProvider` into `AuthRepository`.
  - Call `_supabase.auth.signUp(email: email, password: password, data: {'name': name, 'full_name': name, 'role': role.name})`.
  - Ensure `public.profiles` stores `id` (referencing `auth.users`), `email`, `name`, `full_name`, `role` (`CHECK (role IN ('customer', 'mechanic'))`), `avatar_url`, and `created_at`, backed by an `AFTER INSERT ON auth.users` trigger and Row-Level Security (`auth.uid() = id`) so unconfirmed sessions (`response.session == null`) do not leave orphaned auth users or fail under RLS.
  - Chain `.distinct()` on `AuthRepository.authStateChanges()` so background `tokenRefreshed` events do not trigger redundant stream emissions.
- **Router (`go_router` 13.x):**
  - Configure `goRouterProvider` with `refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges())` and dispose both `refreshListenable` and `GoRouter` in `ref.onDispose`.
  - Whitelist unauthenticated public/auth routes (`/`, `/onboarding`, `/login`, `/register`, `/forgot-password`, `/role-selection`); redirect unauthenticated access to protected routes to `/login`.
  - Redirect authenticated users on auth routes to `/mechanic/home` (`AppUserRole.mechanic`) or `/home` (`AppUserRole.customer`), and enforce cross-role route isolation so customers cannot access `/mechanic/*` and mechanics are routed to `/mechanic/home`.

### References

- [Source: _bmad-output/planning-artifacts/epics.md#Epic 1: User Authentication & Vehicle Profile Management]
- [Source: _bmad-output/project-context.md]
- [Source: pubspec.yaml]

## Tasks / Subtasks

- [x] Task 1: Domain & Model Setup (AC: 1, 2)
  - [x] Define `AppUser` entity and `AppUserRole` enum (`customer`, `mechanic`) in `lib/src/features/auth/domain/app_user.dart` and `UserProfile` entity in `lib/src/features/profile/domain/user_profile.dart`.
  - [x] Implement JSON serialization and Supabase mapping (`fromSupabaseUser`, `fromJson`, `toJson`, value equality) for `AppUser` and `UserProfile`.
- [x] Task 2: Supabase Auth Repository (AC: 1, 2, 3)
  - [x] Create `AuthRepository` and Riverpod providers (`authRepositoryProvider`, `authStateChangesProvider`) in `lib/src/features/auth/data/auth_repository.dart`.
  - [x] Implement `signUpWithEmailAndPassword({required String email, required String password, String? name, AppUserRole role = AppUserRole.customer})`.
  - [x] Implement `signInWithEmailAndPassword(String email, String password)` with user-friendly `AuthException` and network error mapping.
  - [x] Implement `signOut()` and `authStateChanges()`.
- [x] Task 3: Riverpod Auth State Management (AC: 1, 2, 3)
  - [x] Implement `authControllerProvider` in `lib/src/features/auth/application/auth_controller.dart`.
  - [x] Handle async state (`AsyncValue`), loading indicators, and error catching via `AsyncValue.guard`.
- [x] Task 4: UI Onboarding & Auth Screens (AC: 1, 2, 3)
  - [x] Create `OnboardingScreen` in `lib/src/features/onboarding/presentation/onboarding_screen.dart` persisting first-launch completion via `LocalStorageService`.
  - [x] Create `LoginScreen` and `RegisterScreen` with `AppUserRole` selector (`Customer` and `Mechanic`) in `lib/src/features/auth/presentation/`.
  - [x] Connect form validators (non-empty name, email format, 6+ character password, password confirmation match) and submit handlers to `authControllerProvider` and `showAlertDialogOnError`.
- [x] Task 5: Routing & Session Guarding (AC: 1, 2)
  - [x] Update `lib/src/routing/app_router.dart` and `lib/src/features/auth/presentation/splash_screen.dart` to listen to auth state changes, route first-time unauthenticated users to `/onboarding` and returning unauthenticated users to `/login`, and enforce role-specific routing between `/home` and `/mechanic/home`.
- [x] Task 6: Unit, Widget & BDD Tests (AC: 1, 2, 3)
  - [x] Add unit tests for `AppUser`/`UserProfile` serialization, `AuthRepository`, and `AuthController` in `test/unit/auth/auth_repository_test.dart` and `test/unit/auth/auth_controller_test.dart`.
  - [x] Add widget tests for `RegisterScreen` role selection, form validation, and error feedback in `test/widget/register_screen_test.dart`.
  - [x] Add BDD feature scenarios and steps for login and registration flows in `test/features/auth/login.feature` and `test/features/auth/register.feature`.

## Dev Agent Record

### Agent Model Used

Gemini 3.6 Flash

### Completion Notes List

- Implemented `AppUser`, `AppUserRole` (`customer`, `mechanic`), and `UserProfile` JSON/Supabase serialization with `name`/`full_name` compatibility.
- Implemented `AuthRepository` and `AuthController` supporting email/password sign-up with role metadata, profile persistence, sign-in, sign-out, auth state streaming, and friendly error mapping.
- Connected `OnboardingScreen`, `SplashScreen`, `LoginScreen`, `RegisterScreen`, and `goRouterProvider` auth state redirects.
- Added unit, widget, and BDD tests covering `AuthRepository`, `AuthController`, `RegisterScreen`, and auth user flows.
- Updated story specification to resolve review findings across `adversarial`, `edge-case-hunter`, `structure`, and `prose` lenses.

### File List

- `_bmad-output/implementation-artifacts/1-1-user-onboarding-multi-role-registration-supabase-auth-integration.md`
- `_bmad-output/implementation-artifacts/sprint-status.yaml`
- `lib/main.dart`
- `lib/src/common/supabase_config.dart`
- `lib/src/features/auth/application/auth_controller.dart`
- `lib/src/features/auth/application/auth_controller.g.dart`
- `lib/src/features/auth/data/auth_repository.dart`
- `lib/src/features/auth/data/auth_repository.g.dart`
- `lib/src/features/auth/domain/app_user.dart`
- `lib/src/features/auth/presentation/login_screen.dart`
- `lib/src/features/auth/presentation/register_screen.dart`
- `lib/src/features/auth/presentation/splash_screen.dart`
- `lib/src/features/onboarding/presentation/onboarding_screen.dart`
- `lib/src/features/profile/domain/user_profile.dart`
- `lib/src/routing/app_router.dart`
- `lib/src/routing/app_router.g.dart`
- `supabase/migrations/20261108000000_create_profiles_and_auth_trigger.sql`
- `test/helpers/fake_auth_repository.dart`
- `test/unit/auth/auth_controller_test.dart`
- `test/unit/auth/auth_repository_test.dart`
- `test/widget/auth_routing_and_onboarding_test.dart`
- `test/widget/register_screen_test.dart`
- `test/features/auth/login.feature`
- `test/features/auth/login_test.dart`
- `test/features/auth/register.feature`
- `test/features/auth/register_test.dart`
- `test/features/auth/step/the_app_is_running.dart`
- `test/features/auth/step/i_am_on_the_login_screen.dart`
- `test/features/auth/step/i_am_on_the_register_screen.dart`
- `test/features/auth/step/i_enter_john_doe_into_the_name_field.dart`
- `test/features/auth/step/i_enter_testexamplecom_into_the_email_field.dart`
- `test/features/auth/step/i_enter_password123_into_the_password_field.dart`
- `test/features/auth/step/i_enter_password123_into_the_confirm_password_field.dart`
- `test/features/auth/step/i_tap_the_login_button.dart`
- `test/features/auth/step/i_tap_the_sign_up_button.dart`
- `test/features/auth/step/i_should_see_the_home_screen.dart`
