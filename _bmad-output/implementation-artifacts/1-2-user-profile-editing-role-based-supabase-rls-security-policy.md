# Story 1.2: User Profile Editing & Role-Based Supabase RLS Security Policy

Status: ready-for-dev

<!-- Note: Validation is optional. Run validate-create-story for quality check before dev-story. -->

## Story

As an authenticated user,
I want to view and edit my profile details and switch/add service provider roles if needed,
so that my profile remains up to date while enforcing strict data isolation so only authorized users can access my personal data.

## Acceptance Criteria

1. **Profile Viewing & Editing (`ProfileScreen` & `EditProfileScreen`):**
   - **Given** an authenticated user on `ProfileScreen` or `EditProfileScreen`,
   - **When** they update their full name, phone number, or avatar URL/photo and tap "Save Changes",
   - **Then** `EditProfileScreen` awaits completion of the update via `profileControllerProvider` (showing a loading indicator on the button while in-flight), persists the updated values to the Supabase `public.profiles` table (synchronizing `auth.users` metadata for `name`/`full_name` and `avatar_url`), pops back to `ProfileScreen` with a confirmation `SnackBar`, and reactively displays the updated details.
   - **And** if the update fails (e.g., network drop or RLS `PostgrestException`), `EditProfileScreen` remains open, does **not** display a false success message, and surfaces the error via `AsyncValueUI.showAlertDialogOnError(context)`.

2. **Multi-Role Switching & Cross-Role Route Isolation:**
   - **Given** an authenticated user viewing their profile or role selection control (`Customer` vs `Mechanic`),
   - **When** they switch their active role between `AppUserRole.customer` and `AppUserRole.mechanic`,
   - **Then** both `public.profiles.role` AND `supabase.auth.updateUser(UserAttributes(data: {'role': newRole.name}))` are updated so `UserProfile.role` and `AppUser.fromSupabaseUser` stay synchronized.
   - **And** `goRouterProvider` automatically redirects the user to the corresponding role home (`/mechanic/home` for `AppUserRole.mechanic`, `/home` for `AppUserRole.customer`) and prevents `AppUserRole.customer` users from accessing `/mechanic/*` routes (redirecting unauthorized cross-role navigation back to `/home`).

3. **Supabase Row-Level Security (RLS) & Auth Trigger Policy:**
   - **Given** the Supabase Postgres schema in `supabase/migrations/`,
   - **When** accounts are created or `public.profiles` is queried or mutated,
   - **Then** an idempotent SQL migration enforces:
     - `public.handle_new_user()` (`AFTER INSERT ON auth.users`, `SECURITY DEFINER SET search_path = public`) automatically upserts the initial `public.profiles` record so sign-ups with `response.session == null` (email confirmation enabled) never fail RLS.
     - `ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;` is active.
     - `INSERT` and `UPDATE` policies on `public.profiles` strictly enforce `auth.uid() = id` in both `USING` and `WITH CHECK` clauses, rejecting cross-user mutations with PostgREST error code `42501`.
     - `SELECT` policy on `public.profiles` permits authenticated users to read their own profile (`auth.uid() = id`) and permits authenticated profile lookups required for mechanic discovery and chat participant joins (`ChatRepository.fetchChatRoom`).

4. **Profile Settings Reactivity (Dark Mode & Notifications) & Clean Logout:**
   - **Given** an authenticated user on `ProfileScreen`,
   - **When** they toggle Dark Mode or Notifications, or confirm Logout in the confirmation dialog,
   - **Then** `dark_mode_enabled` and `notifications_enabled` persist to `public.profiles`, `AutoEaseApp` (`lib/main.dart`) reactively binds `MaterialApp.router(themeMode: ...)` to the user's `darkModeEnabled` state (instead of hardcoded `ThemeMode.system`), and Logout awaits `profileControllerProvider.notifier.logout()` and lets `goRouterProvider`'s `refreshListenable` redirect to `/login` without manual `context.go('/login')` calls.

## Tasks / Subtasks

- [ ] Task 1: Supabase SQL Migration for `profiles` Table, Auth Trigger & RLS Policies (AC: 1, 2, 3)
  - [ ] Create `supabase/migrations/20261108000001_profiles_rls_and_auth_trigger.sql` using idempotent SQL (`CREATE TABLE IF NOT EXISTS public.profiles`, `ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY`, `DROP POLICY IF EXISTS ...; CREATE POLICY ...`).
  - [ ] Define `public.profiles` columns: `id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE`, `email text NOT NULL DEFAULT ''`, `name text`, `full_name text`, `phone text NOT NULL DEFAULT ''`, `avatar_url text`, `role text NOT NULL DEFAULT 'customer' CHECK (role IN ('customer', 'mechanic'))`, `notifications_enabled boolean NOT NULL DEFAULT true`, `dark_mode_enabled boolean NOT NULL DEFAULT false`, `created_at timestamptz NOT NULL DEFAULT now()`, `updated_at timestamptz NOT NULL DEFAULT now()`.
  - [ ] Create `public.handle_new_user()` trigger function with `SECURITY DEFINER SET search_path = public` and attach `AFTER INSERT ON auth.users` trigger to seed `public.profiles` from `NEW.raw_user_meta_data`.
  - [ ] Define RLS policies: `profiles_select_authenticated` (`FOR SELECT TO authenticated USING (true)` to support own-profile reads, mechanic discovery, and `ChatRepository.fetchChatRoom` participant joins), `profiles_insert_own` (`FOR INSERT TO authenticated WITH CHECK (auth.uid() = id)`), and `profiles_update_own` (`FOR UPDATE TO authenticated USING (auth.uid() = id) WITH CHECK (auth.uid() = id)`).

- [ ] Task 2: Extend `UserProfile` Domain Model with Role & Value Equality (AC: 1, 2)
  - [ ] Update `lib/src/features/profile/domain/user_profile.dart` to import `AppUserRole` from `package:auto_ease/src/features/auth/domain/app_user.dart` and add `final AppUserRole role` (defaulting to `AppUserRole.customer`).
  - [ ] Update `copyWith`, `fromJson` (deserialize `role` via `AppUserRole.values.firstWhere((e) => e.name == json['role'], orElse: () => AppUserRole.customer)`), and `toJson` (include `'name': name`, `'full_name': name`, and `'role': role.name`).
  - [ ] Implement `operator ==`, `hashCode` (`Object.hash(...)`), and `toString()` on `UserProfile`.

- [ ] Task 3: Extract `ProfileRepository` & Synchronize Auth Role Metadata (AC: 1, 2, 3)
  - [ ] Create `lib/src/features/profile/data/profile_repository.dart` (with `part 'profile_repository.g.dart';` and `@Riverpod(keepAlive: true) ProfileRepository profileRepository(Ref ref)`), moving all direct `supabase.from('profiles')` calls out of `ProfileController` to comply with the strict Repository Boundary rule.
  - [ ] Implement `Stream<UserProfile> watchProfile(AppUser user)` using `.from('profiles').stream(primaryKey: ['id']).eq('id', user.uid)`.
  - [ ] Implement `Future<UserProfile> updateProfile({required String uid, String? name, String? email, String? phone, String? avatarUrl, bool? notificationsEnabled, bool? darkModeEnabled, AppUserRole? role})` chaining `.update(updates).eq('id', uid).select().single()` so 0-row RLS rejections surface as errors.
  - [ ] Update `lib/src/features/auth/data/auth_repository.dart`:
    - Chain `.distinct()` on `authStateChanges()` to prevent background JWT `tokenRefreshed` events from tearing down Realtime streams or firing redundant router redirects.
    - Add `Future<void> updateUserMetadata({String? name, AppUserRole? role, String? avatarUrl})` calling `_supabase.auth.updateUser(UserAttributes(data: ...))` so `AppUser.fromSupabaseUser` stays in sync when profile name, avatar, or role is updated.

- [ ] Task 4: Refactor `ProfileController` for Auth Reactivity, Role Switching & Error Propagation (AC: 1, 2, 4)
  - [ ] Update `lib/src/features/profile/application/profile_controller.dart` to watch `authStateChangesProvider` with cold-start fallback (`authAsync.valueOrNull ?? (authAsync.isLoading ? ref.read(authRepositoryProvider).currentUser : null)`) and delegate data streaming/mutations to `profileRepositoryProvider` and `authRepositoryProvider`.
  - [ ] Ensure `updateProfile`, `toggleNotifications`, `toggleDarkMode`, `updateRole(AppUserRole role)`, and `logout()` properly update `state` (`AsyncValue.guard` / optimistic or stream-backed state) and propagate errors when RLS or network failures occur.
  - [ ] Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `profile_repository.g.dart` and `profile_controller.g.dart`.

- [ ] Task 5: Upgrade `ProfileScreen`, `EditProfileScreen`, `MechanicHomeScreen`, `RoleSelectionScreen`, `app_router.dart`, and `main.dart` (AC: 1, 2, 4)
  - [ ] In `lib/src/features/profile/presentation/edit_profile_screen.dart`:
    - Make `_saveProfile()` `async`, await `updateProfile(...)`, guard `BuildContext` with `if (!mounted) return;`, show error via `AsyncValueUI` without popping on failure, and only `context.pop()` + show success `SnackBar` when no error occurred.
    - Render current avatar (`profile.avatarUrl`) in the header `CircleAvatar` and make the camera button interactive (allowing the user to enter/update their avatar URL).
    - Sync text controllers when `profileControllerProvider` finishes initial load.
  - [ ] In `lib/src/features/profile/presentation/profile_screen.dart`:
    - Add a Role Switcher card/tile showing current role (`Customer` vs `Mechanic / Service Provider`) and allowing role switching via `profileControllerProvider.notifier.updateRole(...)`.
    - Fix `_showLogoutDialog` to `await ref.read(profileControllerProvider.notifier).logout()` and remove manual `context.go('/login')`.
    - Replace all 10 deprecated `.withOpacity(...)` calls with `.withValues(alpha: ...)`.
  - [ ] In `lib/src/features/mechanic/presentation/mechanic_home_screen.dart` and `lib/src/features/auth/presentation/role_selection_screen.dart`:
    - Replace deprecated `.withOpacity(...)` in `MechanicHomeScreen` and add an AppBar profile/switch-to-customer action so Mechanics can navigate to `/profile/edit` or switch back to `Customer` role.
    - Connect `RoleSelectionScreen` cards to persist role changes when an authenticated user selects a role.
  - [ ] In `lib/src/routing/app_router.dart`:
    - Register `ref.onDispose` to dispose both `GoRouterRefreshStream` and `GoRouter`.
    - Enforce cross-role route isolation in `redirect`: redirect non-mechanics away from `/mechanic/*` to `/home`, and redirect mechanics from `/home` to `/mechanic/home` (while allowing shared routes like `/profile/edit`).
  - [ ] In `lib/main.dart`:
    - Watch `profileControllerProvider` in `AutoEaseApp` and bind `themeMode` to `profile.darkModeEnabled ? ThemeMode.dark : ThemeMode.light` (defaulting to `ThemeMode.system` when unauthenticated).

- [ ] Task 6: Three-Tier Tests — Unit, Widget, and BDD Feature (AC: 1, 2, 3, 4)
  - [ ] Create shared `FakeAuthRepository` and `FakeProfileRepository` in `test/helpers/` (with RLS `PostgrestException(code: '42501')` simulation when `uid != currentUser?.uid`) and remove duplicated inline fakes where applicable.
  - [ ] Update `test/unit/models/user_profile_model_test.dart` to test `role` serialization/deserialization, `copyWith(role: ...)`, and value equality (`==` / `hashCode`).
  - [ ] Rewrite `test/unit/profile/profile_controller_test.dart` and add `test/unit/profile/profile_repository_test.dart` to test stream emission, `updateProfile`, `updateRole` (verifying both `profiles.role` and auth metadata sync), `toggleNotifications`, `toggleDarkMode`, `logout`, and RLS `42501` unauthorized update rejection.
  - [ ] Add `test/widget/profile_screen_test.dart` (covering `ProfileScreen` & `EditProfileScreen` form validation, async save awaiting, error `SnackBar` on failure without popping, role switch, and dark mode toggle).
  - [ ] Add `test/features/profile/profile_editing.feature` (1–2 Gherkin scenarios verifying end-to-end profile editing and role switching redirect via `bdd_widget_test`).

## Dev Notes

### Developer Context & Guardrails

- **Strict Repository Boundary (`project-context.md`):**
  - Never call `supabase.from('profiles')` directly inside `ProfileController` (`lib/src/features/profile/application/profile_controller.dart`). All PostgREST `.from('profiles')` queries, `.stream(primaryKey: ['id'])` subscriptions, and `.update(...).eq('id', uid).select().single()` mutations MUST live inside `lib/src/features/profile/data/profile_repository.dart`.
- **Dual Role Source-of-Truth Synchronization:**
  - `AppUser.fromSupabaseUser` (`lib/src/features/auth/domain/app_user.dart:21-32`) reads `role` from `user.userMetadata?['role']` and `name` from `user.userMetadata?['name'] ?? user.userMetadata?['full_name']`.
  - `goRouterProvider` (`lib/src/routing/app_router.dart:57-79`) reads `authRepository.currentUser.role` to decide `/home` vs `/mechanic/home`.
  - Therefore, switching roles or updating the user's name MUST update **both** `public.profiles` AND `supabase.auth.updateUser(UserAttributes(data: {'role': ..., 'name': ..., 'full_name': ...}))`, and emit the updated `AppUser` through `authRepository.authStateChanges()` so `GoRouterRefreshStream` immediately re-evaluates routes.

### Audit of Existing Files Being Modified (`UPDATE` Analysis)

1. **`lib/src/features/profile/domain/user_profile.dart`:**
   - *Current state:* Immutable class with `id`, `name`, `email`, `phone`, `avatarUrl`, `notificationsEnabled`, `darkModeEnabled`. `fromJson` reads `(json['full_name'] ?? json['name'])`. `toJson` writes `'full_name'` only. No `role` field, no `==`/`hashCode`.
   - *Changes required:* Add `final AppUserRole role;` (default `AppUserRole.customer`), include `'name': name`, `'full_name': name`, and `'role': role.name` in `toJson()`, parse `role` in `fromJson`, and implement `operator ==` and `hashCode` via `Object.hash`.
   - *Must preserve:* Default values for `notificationsEnabled = true`, `darkModeEnabled = false`, and `role = AppUserRole.customer` so `kTestUserProfile` (`test/helpers/test_data.dart`) and `kMockUserProfile` (`lib/src/features/profile/data/mock_user_profile.dart`) remain valid `const` constructors.

2. **`lib/src/features/profile/application/profile_controller.dart`:**
   - *Current state:* `@riverpod class ProfileController extends _$ProfileController` returning `Stream<UserProfile> build()`. Directly watches `supabaseClientProvider` and `authRepositoryProvider.currentUser` (non-reactive to `authStateChangesProvider`), and executes unguarded `.from('profiles').update(...)` calls.
   - *Changes required:* Watch `authStateChangesProvider` (with cold-start fallback to `ref.read(authRepositoryProvider).currentUser` while `authAsync.isLoading`), delegate stream and mutations to `ProfileRepository`, add `Future<void> updateRole(AppUserRole role)`, and update `state` via `AsyncValue.guard` / optimistic `AsyncData` so `EditProfileScreen` and unit tests can `await` mutations and inspect `ref.read(profileControllerProvider).hasError`.
   - *Must preserve:* Method names `updateProfile`, `toggleNotifications`, `toggleDarkMode`, `logout` expected by `ProfileScreen`, `EditProfileScreen`, and `test/unit/profile/profile_controller_test.dart`.

3. **`lib/src/features/profile/presentation/edit_profile_screen.dart`:**
   - *Current state:* `_saveProfile()` (lines 35–46) fires `updateProfile(...)` without `await`, immediately pops, and shows `'Profile updated successfully'`. Avatar widget (lines 80–115) is a static `Icons.person` with a non-clickable camera icon.
   - *Changes required:* Make `_saveProfile()` `async` with `_isSaving` state, `await` the controller call, check `if (!mounted) return;`, check for error state (surfacing via `showAlertDialogOnError(context)` and aborting `context.pop()` on error), and support editing `avatarUrl` (e.g., via an avatar URL field or dialog triggered by tapping the avatar/camera icon).
   - *Must preserve:* Form validation messages (`'Please enter your name'`, `'Please enter your phone number'`), `GlassCard` layout, and `TextEditingController` disposal in `dispose()`.

4. **`lib/src/features/profile/presentation/profile_screen.dart`:**
   - *Current state:* Renders avatar, name, email, phone, Notifications & Dark Mode switches, About section, and Logout button. Contains 10 deprecated `.withOpacity(...)` calls. `_showLogoutDialog` (lines 353–375) does not `await` `logout()` and calls `context.go('/login')` manually.
   - *Changes required:* Add Role / Account Type section allowing switch between `Customer` and `Mechanic`, make logout `async` (`await ref.read(profileControllerProvider.notifier).logout();` without manual `context.go('/login')`), and replace all `.withOpacity(...)` with `.withValues(alpha: ...)`.
   - *Must preserve:* Existing Personal Information, Settings, About, and Logout sections and error/loading states.

5. **`lib/src/routing/app_router.dart` & `lib/main.dart`:**
   - *Current state:* `goRouterProvider` creates `GoRouterRefreshStream` without `ref.onDispose`, only checks role when `isAuthRoute` is true (allowing a logged-in `customer` to navigate to `/mechanic/home` or stay on `/home` after switching to `mechanic`), and `AutoEaseApp` hardcodes `themeMode: ThemeMode.system`.
   - *Changes required:* Add `ref.onDispose` in `goRouterProvider`, enforce cross-role redirects (`/mechanic/*` <-> `/home`), and bind `themeMode` in `AutoEaseApp` (`lib/main.dart`) to `profileControllerProvider`'s `darkModeEnabled`.

6. **`test/unit/profile/profile_controller_test.dart`:**
   - *Current state:* Written for an older synchronous mock `ProfileController` without provider overrides—currently fails at runtime when `ProfileController` accesses `supabaseClientProvider`.
   - *Changes required:* Update tests to `async` using `createContainer(overrides: [...])` with `FakeProfileRepository` and `FakeAuthRepository`, attaching a listener (`container.listen(profileControllerProvider, (_, __) {})`) and awaiting `container.read(profileControllerProvider.future)` per `project-context.md`.

### Previous Story & Git Intelligence (Story 1.1 Learnings)

- **Dual-Key `name` / `full_name` Compatibility Bridge:** Story 1.1 established in `AuthRepository.signUpWithEmailAndPassword` (`lib/src/features/auth/data/auth_repository.dart:48-65`) and `AppUser.fromJson` (`lib/src/features/auth/domain/app_user.dart:34-51`) that `profiles` and `auth.users` metadata store both `'name'` and `'full_name'`. `UserProfile.toJson()` and `ProfileRepository.updateProfile()` must write both `'name'` and `'full_name'` when updating a user's name so `AppUser` and `UserProfile` never diverge.
- **BDD & Analyzer Coverage:** Commit `67524d4` configured `analysis_options.yaml` to exclude `test/features/**/*.dart` from static analysis while running them in `flutter test`. When adding `test/features/profile/profile_editing.feature`, generate step stubs via `dart run build_runner build --delete-conflicting-outputs` and verify compilation with `flutter test`.
- **Broken Existing `profile_controller_test.dart`:** During the earlier Supabase migration, `ProfileController` was converted to `StreamNotifier<UserProfile>` without updating `test/unit/profile/profile_controller_test.dart` (which still assumes synchronous `kMockUserProfile` state and lacks provider overrides). Task 6 repairs and expands this test suite.

### Library, Framework & Testing Specifics

- **Riverpod 2.6.x (`flutter_riverpod` / `riverpod_generator`):**
  - Use `Ref ref` in functional providers (`@Riverpod(keepAlive: true) ProfileRepository profileRepository(Ref ref)`).
  - Never declare `state` or `ref` fields manually inside `ProfileController extends _$ProfileController`.
  - In unit tests for `autoDispose` `StreamNotifier`s (`profileControllerProvider`), always attach a listener (`final sub = container.listen(profileControllerProvider, (_, __) {}); addTearDown(sub.close);`) and `await container.read(profileControllerProvider.future)` before reading `.requireValue` or calling mutation methods.
- **Supabase v2 (`supabase_flutter` 2.17.2):**
  - `.stream(primaryKey: ['id'])` requires `primaryKey` and supports at most one `.eq('id', user.uid)` filter.
  - Chain `.select().single()` on `profiles` `.update(...)` calls so 0-row RLS rejections throw a `PostgrestException` instead of silently succeeding.
- **Flutter 3.27+ Color API:**
  - Always use `.withValues(alpha: ...)` instead of deprecated `.withOpacity(...)`.

### Project Structure Notes

- **New Files to Create:**
  - `supabase/migrations/20261108000001_profiles_rls_and_auth_trigger.sql`
  - `lib/src/features/profile/data/profile_repository.dart` (+ `profile_repository.g.dart`)
  - `test/unit/profile/profile_repository_test.dart`
  - `test/widget/profile_screen_test.dart`
  - `test/features/profile/profile_editing.feature` (+ generated `profile_editing_test.dart` and `step/*.dart`)
- **Existing Files to Update:**
  - `lib/src/features/profile/domain/user_profile.dart`
  - `lib/src/features/profile/application/profile_controller.dart` (+ `profile_controller.g.dart`)
  - `lib/src/features/profile/presentation/profile_screen.dart`
  - `lib/src/features/profile/presentation/edit_profile_screen.dart`
  - `lib/src/features/auth/data/auth_repository.dart`
  - `lib/src/features/auth/presentation/role_selection_screen.dart`
  - `lib/src/features/mechanic/presentation/mechanic_home_screen.dart`
  - `lib/src/routing/app_router.dart`
  - `lib/main.dart`
  - `test/unit/models/user_profile_model_test.dart`
  - `test/unit/profile/profile_controller_test.dart`

### References

- [Source: `_bmad-output/planning-artifacts/epics.md` — Epic 1, Story 1.2: User Profile Editing & Role-Based Supabase RLS Security Policy]
- [Source: `_bmad-output/project-context.md` — Critical Implementation Rules & Brownfield Prototype Traps]
- [Source: `_bmad-output/implementation-artifacts/1-1-user-onboarding-multi-role-registration-supabase-auth-integration.md` — Story 1.1 Learnings]
- [Source: `docs/lessons_learned.md` — Riverpod Codegen & Deprecated API Guidelines]

## Dev Agent Record

### Agent Model Used

Gemini 4 Argon (Medium)

### Debug Log References

### Completion Notes List

- Ultimate context engine analysis completed - comprehensive developer guide created.

### File List

- `_bmad-output/implementation-artifacts/1-2-user-profile-editing-role-based-supabase-rls-security-policy.md`
- `_bmad-output/implementation-artifacts/sprint-status.yaml`
