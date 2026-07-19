import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/chat/data/chat_repository.dart';

part 'chat_controller.g.dart';

@riverpod
class ChatController extends _$ChatController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> sendMessage(String roomId, String content) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(chatRepositoryProvider).sendMessage(roomId, content),
    );
  }
}
