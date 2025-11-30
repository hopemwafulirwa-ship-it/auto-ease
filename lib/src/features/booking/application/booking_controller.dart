import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'booking_controller.g.dart';

@riverpod
class BookingController extends _$BookingController {
  @override
  BookingState build() {
    return BookingState();
  }

  void setServiceCenterId(String id) {
    state = state.copyWith(serviceCenterId: id);
  }

  void toggleService(String service) {
    final services = List<String>.from(state.selectedServices);
    if (services.contains(service)) {
      services.remove(service);
    } else {
      services.add(service);
    }
    state = state.copyWith(selectedServices: services);
  }

  void setDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  void setTimeSlot(String time) {
    state = state.copyWith(selectedTimeSlot: time);
  }

  void reset() {
    state = BookingState();
  }
}

class BookingState {
  final String? serviceCenterId;
  final List<String> selectedServices;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;

  BookingState({
    this.serviceCenterId,
    this.selectedServices = const [],
    this.selectedDate,
    this.selectedTimeSlot,
  });

  BookingState copyWith({
    String? serviceCenterId,
    List<String>? selectedServices,
    DateTime? selectedDate,
    String? selectedTimeSlot,
  }) {
    return BookingState(
      serviceCenterId: serviceCenterId ?? this.serviceCenterId,
      selectedServices: selectedServices ?? this.selectedServices,
      selectedDate: selectedDate ?? this.selectedDate,
      selectedTimeSlot: selectedTimeSlot ?? this.selectedTimeSlot,
    );
  }
}
