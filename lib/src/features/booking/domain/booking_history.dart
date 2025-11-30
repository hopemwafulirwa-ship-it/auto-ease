enum BookingStatus {
  upcoming,
  completed,
  cancelled,
}

class BookingHistory {
  final String id;
  final String serviceCenterId;
  final String serviceCenterName;
  final List<String> services;
  final DateTime dateTime;
  final BookingStatus status;
  final double totalPrice;
  final String? notes;

  const BookingHistory({
    required this.id,
    required this.serviceCenterId,
    required this.serviceCenterName,
    required this.services,
    required this.dateTime,
    required this.status,
    required this.totalPrice,
    this.notes,
  });

  BookingHistory copyWith({
    String? id,
    String? serviceCenterId,
    String? serviceCenterName,
    List<String>? services,
    DateTime? dateTime,
    BookingStatus? status,
    double? totalPrice,
    String? notes,
  }) {
    return BookingHistory(
      id: id ?? this.id,
      serviceCenterId: serviceCenterId ?? this.serviceCenterId,
      serviceCenterName: serviceCenterName ?? this.serviceCenterName,
      services: services ?? this.services,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
      totalPrice: totalPrice ?? this.totalPrice,
      notes: notes ?? this.notes,
    );
  }
}
