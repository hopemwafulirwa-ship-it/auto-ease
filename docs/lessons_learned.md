# Lessons Learned & Troubleshooting Guide

This document captures known bugs, common pitfalls, and architectural lessons learned during the development of AutoEase. It serves as a living document to prevent recurring issues.

## 1. Supabase Migration & Riverpod Code Generation (Build Errors)
**Problem:** Broken Riverpod providers, incorrect class overrides, and missing code generation.
**Cause:** Migrating models/repositories from Firebase to Supabase changed the signatures of asynchronous methods and properties. Code generation for `.g.dart` files was pointing to old class structures.
**Fix/Recommended Practice:**
- After modifying a model or a Riverpod provider (`@riverpod`), always clean the build cache and regenerate:
  ```bash
  flutter clean
  flutter pub get
  flutter pub run build_runner build --delete-conflicting-outputs
  ```
- Ensure UI components properly handle `AsyncValue` (e.g., `data`, `loading`, `error`) returned by new Supabase-backed FutureProviders.

## 2. Riverpod Controller Errors (`auth_controller.dart`)
**Problem:** Errors such as `uri_has_not_been_generated`, `undefined_identifier` for `state` and `ref`, or `override_on_non_overriding_member`.
**Cause:** Incorrectly defining `state` or attempting to override `build()` manually in a way that conflicted with the `_$AuthController` generated class, or forgetting to include the `.g.dart` import snippet.
**Fix/Recommended Practice:**
- Make sure to declare `part 'auth_controller.g.dart';` at the top.
- Do not manually declare `state` or `ref` in Riverpod Notifier classes; they are provided by the `_$()` generated class.
- Only override the `build()` method with the correct return type matching the annotation.

## 3. Lingering Firebase Dependencies
**Problem:** Build bloat, ambiguous imports, and initialization conflicts.
**Cause:** Attempting to run a newly migrated Supabase app while still initializing `Firebase.initializeApp()` in `main.dart`, or having residual pubspec.yaml dependencies.
**Fix/Recommended Practice:**
- Remove all `firebase_*` dependencies from `pubspec.yaml`.
- Search the codebase for `import 'package:firebase` and remove them.
- Clean out native configuration files: `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
- Remove the classpath for google services in `android/build.gradle` and the plugin application in `app/build.gradle`.

## 4. Deprecated Methods & Packages
**Problem:** Spurious analyzer warnings about deprecated methods across `chat_repository.dart`, `mechanic_repository.dart`, `app_router.dart`, and `auth_repository.dart`.
**Cause:** Underlying dependency updates (e.g., GoRouter or Supabase) introduced API changes (such as deprecating `GoRoute` properties or old builder signatures).
**Fix/Recommended Practice:**
- Promptly replace deprecated methods with the new, supported APIs to avoid them breaking in a subsequent minor/major version update.
- Specifically for routing: check `GoRouter` documentation.
- For Supabase: ensure RPC calls and query methods use the latest v2 syntax.

---

*Note: Update this document organically as new major issues are encountered and resolved.*
