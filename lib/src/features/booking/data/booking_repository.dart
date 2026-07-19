import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:auto_ease/src/common/supabase_client_provider.dart';
import 'package:auto_ease/src/features/booking/domain/booking_history.dart';
import 'package:auto_ease/src/features/auth/data/auth_repository.dart';

part 'booking_repository.g.dart';

class BookingRepository {
  final SupabaseClient _supabase;

  BookingRepository(this._supabase);

  Stream<List<BookingHistory>> watchUserBookings(String userId) {
    return _supabase
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('booking_date', ascending: false)
        .map((data) =>
            data.map((json) => BookingHistory.fromJson(json)).toList());
  }

  Future<void> createBooking({
    required String userId,
    required String serviceCenterId,
    required List<String> services,
    required DateTime dateTime,
    required double totalPrice,
    String? notes,
  }) async {
    await _supabase.from('bookings').insert({
      'user_id': userId,
      'service_center_id': serviceCenterId,
      'services': services,
      'booking_date': dateTime.toIso8601String(),
      'status': 'upcoming',
      'total_price': totalPrice,
      'notes': notes,
    });
  }

  Future<void> cancelBooking(String bookingId) async {
    await _supabase
        .from('bookings')
        .update({'status': 'cancelled'}).eq('id', bookingId);
  }
}

@riverpod
BookingRepository bookingRepository(ref) {
  return BookingRepository(ref.watch(supabaseClientProvider));
}

@riverpod
Stream<List<BookingHistory>> userBookings(ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(bookingRepositoryProvider).watchUserBookings(user.uid);
}
