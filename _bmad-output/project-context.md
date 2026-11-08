---
project_name: 'auto-ease'
user_name: 'Monsta'
date: '2026-11-08'
sections_completed:
  ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'quality_rules', 'workflow_rules', 'anti_patterns']
status: 'complete'
rule_count: 58
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

---

## Technology Stack & Versions

- **Language & SDK:** Dart `>=3.2.0 <4.0.0`, Flutter `3.2+` (Material 3 enabled, Android `minSdkVersion 21`)
- **State Management & Codegen:** `flutter_riverpod: ^2.5.1` (locked `2.6.1`), `riverpod_annotation: ^2.3.5` (locked `2.6.1`), `riverpod_generator: ^2.6.4` (locked `2.6.5`), `build_runner: ^2.4.8`
  - *Version Note:* Riverpod `2.6.x` uses generic `Ref ref` for functional providers (not deprecated generated `*Ref` typedefs).
- **Navigation:** `go_router: ^13.1.0` (locked `13.2.5`) — uses `state.matchedLocation` and `GoRouterRefreshStream`
- **Backend & Local Storage:** `supabase_flutter: ^2.8.0` (locked `2.17.2` — Supabase v2 API for Auth, PostgREST, Realtime, Storage), `shared_preferences: ^2.5.3` (locked `2.5.5`)
- **Maps & Location:** `google_maps_flutter: ^2.5.0` (locked `2.18.1`), `geolocator: ^10.1.0` (locked `10.1.1`)
- **UI & Utilities:** `google_fonts: ^6.1.0`, `flutter_animate: ^4.5.0`, `intl: ^0.18.0` (locked `0.18.1`), `cupertino_icons: ^1.0.2`
- **Testing & Linting:** `flutter_test`, `bdd_widget_test: ^1.7.6` (locked `1.8.2`), `network_image_mock: ^2.1.1`, `flutter_lints: ^3.0.0`, `riverpod_lint: ^2.6.4`, `custom_lint: ^0.7.6`
- **Not Installed (Do NOT Import Without Adding to `pubspec.yaml`):**
  - **NO Firebase packages** (`firebase_core`, `firebase_auth`, `cloud_firestore` were migrated away—never re-introduce)
  - **NO `freezed` or `json_serializable`** (models use manual `fromJson`/`toJson`/`copyWith` despite `**/*.freezed.dart` in `analysis_options.yaml`)
  - **NO `mocktail` or `mockito`** (tests use hand-written `implements` fakes and `ProviderScope` / `ProviderContainer` overrides)

## Critical Implementation Rules

### Language-Specific Rules (Dart 3.2+)

- **Imports & Part Directives:**
  - **Importing `lib/` files:** Use `package:auto_ease/src/...` imports (opinionated codebase convention over Effective Dart's relative imports to keep paths stable when moving files).
  - **Importing `test/` files:** MUST use relative imports (e.g., `import '../../helpers/create_container.dart';` or `import './step/...';`) because Dart `package:` URIs cannot resolve outside `lib/`, and `bdd_widget_test` generates relative step imports.
  - **Part Directives:** Use relative `part '<file>.g.dart';` placed directly below all `import` statements.
- **Manual Domain Models & PostgREST Serialization:**
  - Map `snake_case` Postgres/JSON keys (`service_center_id`, `avatar_url`) to `camelCase` Dart fields.
  - **PostgREST Numeric Quirk:** Never cast JSON floats directly `as double`; always use `(json['field'] as num).toDouble()` or `(json['field'] as num?)?.toDouble() ?? 0.0` (PostgREST serializes whole-number floats as JSON integers).
  - **List & Enum Casts:** Cast JSON arrays via `List<String>.from(json['list_field'] ?? [])`. Serialize enums with `.name` and deserialize with `EnumType.values.firstWhere((e) => e.name == json['field'], orElse: () => EnumType.defaultVal)`. Serialize `DateTime` with `.toIso8601String()`.
  - **Value Equality (`Object.hash` vs `Object.hashAll`):** Implement `const` constructors, `copyWith`, `operator ==`, and `hashCode`. Use `Object.hash(...)` for models with <=20 fields, and `Object.hashAll([...])` for models with >20 fields (Dart's `Object.hash` maxes out at 20 positional args).
  - **Legacy `profiles` Dual-Key Workaround:** Reading `(json['full_name'] ?? json['name'])` and writing both `'name'` and `'full_name'` is a legacy compatibility bridge **strictly limited to `profiles` / `auth.users` metadata**. Do NOT replicate dual-column naming in new tables.
- **Error Handling & Stack Trace Preservation:**
  - Avoid throwing raw `Exception('...')` where possible, as it discards error types and stack traces and relies on brittle `'Exception: '` string-stripping in `AsyncValueUI`.
  - Prefer typed domain/app exceptions (`class AppException implements Exception` with a `message` getter, optional `cause`/`stackTrace`, and `@override String toString() => message;`) or `Error.throwWithStackTrace(...)` when rethrowing caught SDK exceptions (`AuthException`, `PostgrestException`).
  - In the UI layer, surface `AsyncValue` errors via `ref.listen(..., (_, state) => state.showAlertDialogOnError(context))` (`lib/src/common/utils/async_value_ui.dart`), which renders a floating `SnackBar`.
- **Compiler & Linter Enforcement (`analysis_options.yaml`):**
  - Enforce `prefer_const_constructors` and `prefer_const_literals_to_create_immutables`.
  - Never use `print()` (`avoid_print: true`); use `debugPrint()` from `package:flutter/foundation.dart`.
  - Guard every post-`await` `BuildContext` access with `if (!context.mounted) return;` (`use_build_context_synchronously: true`).

### Framework-Specific Rules (Flutter, Riverpod, Supabase & GoRouter)

- **Riverpod Architecture & Lifecycle (`flutter_riverpod` 2.6.x):**
  - **Codegen Syntax:** `@riverpod` is shorthand for `@Riverpod(keepAlive: false)` (both default to `autoDispose: true`). Never manually declare `state` or `ref` fields inside `_$<ClassName>` Notifier subclasses.
  - **`Ref` Typing:** In `@riverpod` classes, `ref` is implicitly available via `build()`. In functional providers, explicitly type the parameter as `Ref ref` (`import 'package:flutter_riverpod/flutter_riverpod.dart';`), never untyped `ref` or deprecated `*Ref` typedefs.
  - **Wizard & Singleton Lifecycle:** Use `@Riverpod(keepAlive: true)` for singleton infrastructure (`supabaseClientProvider`, `authRepositoryProvider`, `goRouterProvider`) AND multi-step wizard controllers (e.g., `BookingController`) so back-navigation never wipes user progress. Wizard controllers MUST explicitly reset state via `ref.invalidateSelf()` (or `ref.invalidate(...)`) on flow completion or cancellation to prevent memory leaks.
  - **Preventing Cold-Start Auth Flash:** Watching `authStateChangesProvider.value` alone returns `null` during the initial `AsyncLoading` frame on cold start. User-scoped providers must subscribe to `authStateChangesProvider` for reactivity while falling back to the synchronous session during initial load:
    ```dart
    final authAsync = ref.watch(authStateChangesProvider);
    final user = authAsync.valueOrNull ??
        (authAsync.isLoading ? ref.read(authRepositoryProvider).currentUser : null);
    ```
  - **Framework Naming Collisions:** Never name Riverpod Notifiers, Providers, or State classes after *any* Flutter framework class (`SearchController`, `TabController`, `PageController`, `MenuController`, `ScrollController`, `TextEditingController`, `FocusNode`).
- **Supabase v2 (`supabase_flutter`), RLS Security & Data Layering:**
  - **Client Injection & Environment Config:** Never call `Supabase.instance.client` anywhere **except inside the definition of `supabaseClientProvider` itself**. Load `supabaseUrl` and `supabaseAnonKey` in `lib/src/common/supabase_config.dart` via `String.fromEnvironment('SUPABASE_URL')` / `--dart-define` (or `envied`/`flutter_dotenv` if added)—never hardcode new credentials or API keys in feature code.
  - **Repository Boundary:** All `.from(...)`, `.rpc(...)`, and `.storage` calls belong strictly in `lib/src/features/<feature>/data/<feature>_repository.dart`, never inside `application/` controllers or `presentation/` widgets.
  - **RLS & Role Integrity:** Never rely on client-side `.eq('user_id', ...)` or client-writable `auth.users.raw_user_meta_data` (`userMetadata`) alone for authorization. All user/role data isolation must be enforced by Supabase Row-Level Security (`auth.uid() = id` / `auth.uid() = user_id`) and verified against the `profiles` table.
  - **Mutations & Global UI Error Strategy:** Wrap all controller mutations in `state = const AsyncValue.loading(); state = await AsyncValue.guard(() => ...);` so Supabase RLS/PostgREST errors are captured in `AsyncError`. In `presentation/` screens, register `ref.listen<AsyncValue<T>>(provider, (_, state) => state.showAlertDialogOnError(context));` inside `build()` to surface errors consistently via the app's floating `SnackBar` presenter (`lib/src/common/utils/async_value_ui.dart`).
  - **Query, Join & Stream Rules:**
    - Use `.maybeSingle()` when a record may legitimately not exist, and `.single()` only when 0 rows is an exception.
    - For `.stream(primaryKey: ['id'])`, always pass `primaryKey` so the SDK can reconcile `UPDATE`/`DELETE` events. Supabase Realtime streams support at most **one** server-side filter expression (e.g., `.eq('id', uid)` or `.eq('user_id', uid)`)—never chain multiple `.eq()` filters on a `.stream()`, and note that filtering `DELETE` events on non-PK columns requires `REPLICA IDENTITY FULL` on the Postgres table.
    - Never execute N+1 `.single()` queries inside `.stream().asyncMap(...)` loops. Instead, use PostgREST relational JSON expansion (`select('*, related_table(*)')`), Postgres Views, or `.rpc()` functions.
- **GoRouter (`go_router` 13.x) & UI Conventions:**
  - **Path Matching, URI & `state.extra` Safety:** Use `state.matchedLocation` for route-guard path matching (excludes query parameters) and `state.uri.toString()` when full URI + query parameters are needed. Always pass entity IDs via `state.pathParameters['id']` and load data via Riverpod—never cast `state.extra as T` non-nullably, as `extra` is lost on deep-links and process restoration.
  - **Route Protection & Cross-Role Isolation:** All route guards live in `goRouterProvider` (`lib/src/routing/app_router.dart`) using `refreshListenable: GoRouterRefreshStream(authRepository.authStateChanges())`:
    - Unauthenticated users are restricted to public/auth routes (`/`, `/onboarding`, `/login`, `/register`, `/forgot-password`, `/role-selection`, and guest map exploration when enabled); all other paths redirect to `/login`.
    - Authenticated users hitting auth routes redirect by role (`AppUserRole.mechanic` -> `/mechanic/home`, `AppUserRole.customer` -> `/home`), AND role-prefixed routes (`/mechanic/*`) must redirect non-mechanics back to `/home`.
    - Always register `ref.onDispose` in `goRouterProvider` to dispose both the `GoRouterRefreshStream` subscription and the `GoRouter` instance.
  - **Flutter 3.27+ Color API:** Use `color.withValues(alpha: ...)` instead of deprecated `color.withOpacity(...)`.

### Testing Rules

- **Three-Tier Boundaries (Zero Duplication):**
  - `test/unit/<feature>/` & `test/unit/models/`: Pure Dart tests for `fromJson`/`toJson` edge cases, repository PostgREST/RLS error mapping, and controller `AsyncValue` transitions via `createContainer(overrides: [...])` (`test/helpers/create_container.dart`) and `test/helpers/test_data.dart`. Always call `container.dispose()` in `tearDown`.
  - `test/widget/`: Single-screen UI tests (`ProviderScope` + `MaterialApp(home: Screen())`) for form validation permutations, loading states, and `AsyncValueUI` error `SnackBar`s—never duplicate field-validation permutations in BDD `.feature` files.
  - `test/features/<feature>/`: 1–2 Gherkin `.feature` scenarios per story verifying multi-screen Acceptance Criteria and real `goRouterProvider` redirects (`bdd_widget_test`).
- **Riverpod, Async & Timer Discipline:**
  - **Keep `autoDispose` Alive:** Before calling async methods on an `autoDispose` provider in unit tests, attach a listener (`final sub = container.listen(provider, (_, __) {}); addTearDown(sub.close);`) so state isn't disposed mid-`await`.
  - **Await Initial Load:** Always `await container.read(streamOrAsyncProvider.future)` before reading `.requireValue` on a `StreamNotifier` or `AsyncNotifier`.
  - **Cancel Timers:** Cancel every `Timer` / `Timer.periodic` in `ref.onDispose(timer.cancel)` or widget `dispose()` to prevent pending-timer teardown failures.
- **Fakes, RLS Fidelity & Platform Isolation (No `mocktail`/`mockito`):**
  - **One Shared Fake Per Repo:** Define reusable `Fake<Feature>Repository implements <Feature>Repository` classes once in `test/helpers/` (with `StreamController.broadcast()`, a `dispose()` method, and RLS `PostgrestException(code: '42501')` simulation when `userId != currentUser?.uid`). Never duplicate `implements <Repository>` classes across test files.
  - **Real Repository & SQL Coverage:** `*_repository_test.dart` must instantiate the real `<Feature>Repository` (via mock HTTP `Client` / fake `SupabaseClient`) to verify table/column names and error mapping. Chain `.select().single()` on RLS-guarded `UPDATE`/`DELETE` calls to detect 0-row silent rejections, and pair every new RLS policy/RPC/trigger in `supabase/migrations/` with authorized + `42501` unauthorized test cases.
  - **Platform & Router Isolation:** Never hit `Supabase.instance.client` in tests. Wrap static platform plugins like `Geolocator` in a Riverpod service (`locationServiceProvider`), never block UI/marker state on `GoogleMap.onMapCreated` (never fires in headless `flutter test`), and test against the real `goRouterProvider` rather than shadow `GoRouter` instances.
- **BDD & Widget Ergonomics:**
  - **Analyzer Blind Spot:** `analysis_options.yaml` excludes `test/features/**/*.dart`—always run `flutter test` (not just `flutter analyze`) to catch BDD compile errors.
  - **`bdd_widget_test` Syntax:** Never hand-edit generated `*_test.dart` files. Use curly braces (`{'value'}`) in `.feature` files to generate reusable parameterized steps instead of literal-slugged filenames.
  - **Scrolling, Assets & Animations:** Call `await tester.ensureVisible(finder); await tester.pumpAndSettle();` before tapping buttons on scrollable screens; mock platform/network dependencies via `SharedPreferences.setMockInitialValues({})`, `GoogleFonts.config.allowRuntimeFetching = false`, and `mockNetworkImagesFor(...)`; and use `tester.pump(Duration)` instead of `pumpAndSettle()` on screens with repeating animations (`ServiceTrackingScreen`).

### Code Quality & Style Rules

- **Feature-First 4-Layer Architecture (`lib/src/features/<feature>/`):**
  - `domain/`: Pure Dart immutable models and enums (`*_model.dart` or `<entity>.dart`). No `flutter/material.dart` or Riverpod controller imports.
  - `data/`: `<feature>_repository.dart` (+ `.g.dart`) for all Supabase I/O and repository providers.
  - `application/`: `<feature>_controller.dart` (+ `.g.dart`) for Riverpod `Notifier` / `AsyncNotifier` / `StreamNotifier` state management.
  - `presentation/`: Screens (`*_screen.dart`) and feature-specific UI components (`*_card.dart`, `*_bottom_sheet.dart`, `*_widget.dart`).
  - **Shared Primitives (`lib/src/common/`):** Reuse `GlassCard`, `GlassContainer`, `GradientBackground` (`.subtle`, `.primary`, `.accent`), and `AnimatedButton` from `lib/src/common/widgets/` instead of duplicating `BackdropFilter` or gradient `BoxDecoration` boilerplate inside screens.
- **Theme, Typography & Dark Mode Compliance (`lib/src/common/theme/app_theme.dart`):**
  - **No Hardcoded Colors or Fonts:** Always pull colors from `Theme.of(context).colorScheme` and semantic status colors from the `ThemeColors` context extension (`context.successColor`, `context.warningColor`, `context.errorColor`, `context.infoColor` in `app_theme.dart`) instead of raw `Colors.green`/`Colors.orange`/`Colors.black` literals that break dark mode.
  - **Typography:** Read text styles from `Theme.of(context).textTheme` (which pre-configures `GoogleFonts.outfit` for display/headlines and `GoogleFonts.inter` for body/labels) rather than calling `GoogleFonts.*` ad-hoc in widget trees.
  - **Accessibility (`UX-DR2`):** Maintain minimum `48x48` dp touch targets on all interactive controls and preserve high contrast across both `AppTheme.lightTheme` and `AppTheme.darkTheme`.
- **Naming & Resource Cleanup Conventions:**
  - **Files:** `snake_case.dart`; **Types:** `PascalCase`; **Generated Providers:** `<camelCaseName>Provider`; **Test Fixtures/Constants:** `kPascalCase` (`kTestUserProfile`).
  - **Stateful Widget Disposal:** Every `TextEditingController`, `AnimationController`, `ScrollController`, `FocusNode`, or `StreamSubscription` created in a `State` / `ConsumerState` MUST be disposed in `dispose()` before `super.dispose()`.

### Development Workflow Rules

- **Code Generation (`build_runner`) & `bdd_widget_test` Mechanics:**
  - `build.yaml` scopes codegen to `lib/**`, `test/**`, and `web/**` (driving both `riverpod_generator` `.g.dart` files and `bdd_widget_test` `*_test.dart` + `step/*.dart` stubs).
  - **Riverpod Changes:** Whenever an `@riverpod` provider signature or Notifier class changes, run:
    ```bash
    dart run build_runner build --delete-conflicting-outputs
    ```
  - **BDD `.feature` Mechanics (`*_test.dart` vs `./step/*.dart`):**
    - `build_runner` always overwrites `*_test.dart`, but **only creates `./step/*.dart` files if they do not already exist on disk** (it never overwrites existing `./step/*.dart` files).
    - For new steps: (1) edit `.feature` -> (2) run `dart run build_runner build --delete-conflicting-outputs` to generate the exact `./step/*.dart` stub -> (3) implement the generated stub.
    - When changing an existing step's parameter signature (e.g., converting `"literal"` to `{'param'}`), **delete the old `./step/*.dart` file first** before running `build_runner` so the stub regenerates with the updated function parameters.
  - Commit all updated `.g.dart`, `*_test.dart`, and `step/*.dart` files alongside source changes.
- **Supabase SQL Migration Workflow (`supabase/migrations/`):**
  - Name migration files using the Supabase timestamp convention: `YYYYMMDDHHMMSS_<snake_case_description>.sql`.
  - Write migrations idempotently (`CREATE TABLE IF NOT EXISTS`, `ALTER TABLE ... ENABLE ROW LEVEL SECURITY`, `DROP POLICY IF EXISTS ...; CREATE POLICY ...`).
  - **Sandbox Note:** `supabase/config.toml` and local Docker containers are not running in the agent sandbox—author and commit SQL migrations in `supabase/migrations/` and verify behavior via Dart repository/controller tests rather than running `supabase start` / `supabase db reset`.
- **Pre-Completion Verification Gate:**
  - Before marking any task or story complete, run and pass BOTH:
    1. `flutter analyze` (must pass with 0 errors/warnings; note `custom_lint` is in `pubspec.yaml` but not currently enabled under `analyzer: plugins:` in `analysis_options.yaml`)
    2. `flutter test` (must pass 100%, including `test/features/` which `flutter analyze` excludes)
- **Git & BMad Artifact Hygiene:**
  - Never use blind `git add .` or `git add -A` (`.gitignore` currently contains stray ` ``` ` fences and omits `.dart_tool/`, so `git add .` will stage cache/build artifacts). Always check `git status --short` and stage explicit file paths (`git add <path>`).
  - Use Conventional Commit prefixes (`feat:`, `fix:`, `chore:`, `test:`, `refactor:`).
  - Keep `_bmad-output/implementation-artifacts/sprint-status.yaml` and the active story file in `_bmad-output/implementation-artifacts/` synchronized, and log non-obvious troubleshooting findings in `docs/lessons_learned.md`.

### Critical Don't-Miss Rules

- **Brownfield Prototype Traps (Audit Before Trusting Existing Code):**
  - **Await All UI Mutations:** Never fire-and-forget async controller calls (as in `EditProfileScreen._saveProfile()`). Always `await` the mutation, check `if (!context.mounted) return;`, and verify `!ref.read(provider).hasError` before popping or showing success `SnackBar`s.
  - **No Manual Auth Navigation:** Never call `context.go('/login')` or `context.go('/home')` inside `signIn`/`signUp`/`signOut` callbacks (`ProfileScreen._showLogoutDialog`); `await` the auth action and let `goRouterProvider`'s `refreshListenable` redirect.
  - **Sync Role & Theme Sources of Truth:**
    - `AppUser.fromSupabaseUser` reads `role` from `user.userMetadata['role']` while `ProfileController` reads from `profiles`. Role switches (Story 1.2) MUST update both `profiles.role` and `supabase.auth.updateUser(UserAttributes(data: {'role': ...}))`.
    - `AutoEaseApp` (`lib/main.dart`) currently hardcodes `themeMode: ThemeMode.system`; bind it to the user's `darkModeEnabled` state so `ProfileScreen`'s Dark Mode toggle works.
  - **Replace Stubs, Fix `CalendarDatePicker` Init, & Retire `mock_*.dart`:** Audit screens for prototype no-ops (`BookingConfirmationScreen` stub, `ReviewScreen` missing `bookingId`, `DateTimePickerScreen` leaving `selectedDate == null` when `CalendarDatePicker` highlights `DateTime.now()`—initialize with `DateUtils.dateOnly(...)`). Never import `mock_*.dart` in production code, and check whether a consumer expects `AppUser` vs `UserProfile` or `Booking` vs `BookingHistory`.
- **Database, RLS & Domain Integrity Invariants:**
  - **`auth.users` Trigger + Join-Safe `profiles` RLS:** Seed initial `profiles` rows via an `AFTER INSERT ON auth.users` trigger (`SECURITY DEFINER SET search_path = public`) so sign-ups with `response.session == null` don't fail RLS. Lock `profiles` `INSERT`/`UPDATE` to `auth.uid() = id` (blocking unauthorized `role` escalation), while allowing authenticated `SELECT` joins (`ChatRepository.fetchChatRoom`) and mechanic discovery.
  - **Guest Discovery vs. Protected Action Routes (Story 2.1):** Whitelist discovery routes (`/service-finder`, `/home` browse) for unauthenticated guests, but gate action routes (`/booking/*`, `/chat/*`, `/profile/edit`, `/mechanic/*`) to redirect guests to `/login`.
  - **Soft-Delete Vehicles Only:** Never `.delete()` rows from `vehicles`—always `.update({'is_deleted': true})` and filter active vehicles via `.eq('is_deleted', false)` to preserve foreign-key history (Epic 5).
  - **Idempotent Atomic Booking RPC & State Machine:** Normalize booking dates to UTC (`.toUtc().toIso8601String()`) and submit with a UUID idempotency key to an atomic Supabase RPC (`SELECT ... FOR UPDATE`, `SET search_path = public`) that reads `auth.uid()` and server-side prices (never trusting client `user_id` or `total_price`). Customers may only transition their booking to `cancelled` (from `pending`/`upcoming`); only the assigned Mechanic may advance `accepted` -> `in_progress` -> `completed`.
  - **Completion Lifecycle & `COALESCE` Rating Triggers:** Marking a booking `completed` must stop mechanic GPS polling, archive the chat room as read-only, and unlock review submission (`UNIQUE (booking_id)`, `CHECK (rating BETWEEN 1 AND 5)`). Rating triggers must use `COALESCE(ROUND(AVG(rating)::numeric, 2), 0.0)` so `0`-review states never write `NULL` to `service_centers.rating`.
- **Realtime, Storage & Performance Gotchas:**
  - **Decouple JWT Refresh from Realtime Streams:** Chain `.distinct()` on `AuthRepository.authStateChanges()` and watch `authStateChangesProvider.select((s) => s.valueOrNull?.uid)` so background `tokenRefreshed` events don't tear down active Supabase `.stream()` WebSockets or trigger spurious router redirects.
  - **Offline Resilience (`NFR3`):** When `asyncValue.hasValue` is true, retain last known data (`valueOrNull` / `skipError: true`) and show a non-blocking offline banner/snackbar rather than replacing the screen with an error widget on transient network drops.
  - **Path-Scoped Private Storage (`<= 10MB`):** Compress media client-side (`<= 10MB`), store under `<booking_id>/<uploader_uid>/<filename>` in private buckets accessed via `.createSignedUrl(...)`, and enforce `storage.objects` RLS via `(storage.foldername(name))[1]` participant checks.
  - **Adaptive Geolocation & 60 FPS Map Clustering:** Poll mechanic GPS at adaptive `5–10s` intervals (cancelled on disposal/completion) and compute marker clustering/filtering in Riverpod state (`<1.5s` map load, `60 FPS`).

---

## Usage Guidelines

**For AI Agents:**

- Read this file before implementing any code
- Follow all rules exactly as documented
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

**For Humans:**

- Keep this file lean and focused on agent needs
- Update when technology stack or patterns change
- Review quarterly for outdated rules
- Remove rules that become obvious over time

_Last Updated: 2026-11-08_


