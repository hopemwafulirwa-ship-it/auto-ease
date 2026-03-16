/// Helper to create a [ProviderContainer] for Riverpod unit tests.
///
/// Usage:
/// ```dart
/// final container = createContainer();
/// final controller = container.read(bookingControllerProvider.notifier);
/// ```
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Creates a [ProviderContainer] with optional overrides.
///
/// The container is automatically disposed after the test when used
/// with [addTearDown] in a test body.
ProviderContainer createContainer({
  List<Override> overrides = const [],
}) {
  final container = ProviderContainer(overrides: overrides);

  // Note: call addTearDown(container.dispose) in your test setUp or test body
  // to ensure cleanup. We don't do it here because this is a plain function,
  // not a test lifecycle hook.

  return container;
}
