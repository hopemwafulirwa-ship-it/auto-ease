import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/features/booking/data/booking_repository.dart';

part 'booking_history_controller.g.dart';

@riverpod
class BookingHistoryController extends _$BookingHistoryController {
  @override
  Stream<List<BookingHistory>> build() {
    return ref.watch(userBookingsProvider.stream);
  }

  List<BookingHistory> getUpcomingBookings(List<BookingHistory> bookings) {
    return bookings
        .where((b) => b.status == BookingStatus.upcoming)
        .toList();
  }

  List<BookingHistory> getPastBookings(List<BookingHistory> bookings) {
    return bookings
        .where((b) => b.status == BookingStatus.completed || b.status == BookingStatus.cancelled)
        .toList();
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      await ref.read(bookingRepositoryProvider).cancelBooking(bookingId);
    } catch (e) {
      // Assuming UI will handle errors if they bubble up, or we can just log
      rethrow;
    }
  }
}
