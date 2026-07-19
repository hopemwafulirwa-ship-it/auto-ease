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

  factory BookingHistory.fromJson(Map<String, dynamic> json) {
    return BookingHistory(
      id: json['id'] as String,
      serviceCenterId: json['service_center_id'] as String,
      serviceCenterName: json['service_center_name'] as String? ?? 'Unknown Service Center',
      services: List<String>.from(json['services'] ?? []),
      dateTime: DateTime.parse(json['booking_date'] as String),
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'] as String?,
        orElse: () => BookingStatus.upcoming,
      ),
      totalPrice: (json['total_price'] as num).toDouble(),
      notes: json['notes'] as String?,
    );
  }

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
