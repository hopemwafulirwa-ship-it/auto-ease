class Booking {
  final String id;
  final String serviceCenterId;
  final String userId;
  final List<String> selectedServices;
  final DateTime date;
  final String timeSlot;
  final String status; // 'pending', 'confirmed', 'cancelled'
  final double totalPrice;

  const Booking({
    required this.id,
    required this.serviceCenterId,
    required this.userId,
    required this.selectedServices,
    required this.date,
    required this.timeSlot,
    required this.status,
    required this.totalPrice,
  });
}
