class JobRequest {
  final String id;
  final String customerId;
  final String customerName;
  final String customerAvatar;
  final String vehicleInfo;
  final List<String> services;
  final DateTime requestedDateTime;
  final String location;
  final double distance; // in km
  final double estimatedEarnings;
  final JobStatus status;
  final String? address;

  const JobRequest({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerAvatar,
    required this.vehicleInfo,
    required this.services,
    required this.requestedDateTime,
    required this.location,
    required this.distance,
    required this.estimatedEarnings,
    required this.status,
    this.address,
  });
}

enum JobStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled,
}
