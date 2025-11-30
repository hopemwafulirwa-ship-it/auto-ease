import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/features/booking/data/mock_booking_history.dart';

part 'booking_history_controller.g.dart';

@riverpod
class BookingHistoryController extends _$BookingHistoryController {
  @override
  List<BookingHistory> build() {
    return kMockBookingHistory;
  }

  void addBooking(BookingHistory booking) {
    state = [...state, booking];
  }

  void cancelBooking(String bookingId) {
    state = state.map((booking) {
      if (booking.id == bookingId) {
        return booking.copyWith(status: BookingStatus.cancelled);
      }
      return booking;
    }).toList();
  }

  List<BookingHistory> getUpcomingBookings() {
    return state
        .where((booking) => booking.status == BookingStatus.upcoming)
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<BookingHistory> getPastBookings() {
    return state
        .where((booking) =>
            booking.status == BookingStatus.completed ||
            booking.status == BookingStatus.cancelled)
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }
}
