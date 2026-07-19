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

  JobRequest copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerAvatar,
    String? vehicleInfo,
    List<String>? services,
    DateTime? requestedDateTime,
    String? location,
    double? distance,
    double? estimatedEarnings,
    JobStatus? status,
    String? address,
  }) {
    return JobRequest(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerAvatar: customerAvatar ?? this.customerAvatar,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      services: services ?? this.services,
      requestedDateTime: requestedDateTime ?? this.requestedDateTime,
      location: location ?? this.location,
      distance: distance ?? this.distance,
      estimatedEarnings: estimatedEarnings ?? this.estimatedEarnings,
      status: status ?? this.status,
      address: address ?? this.address,
    );
  }

  factory JobRequest.fromJson(Map<String, dynamic> json) {
    return JobRequest(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      customerName: json['customer_name'] as String? ?? 'Unknown', // This might need a join or profile fetch
      customerAvatar: json['customer_avatar'] as String? ?? '',
      vehicleInfo: json['vehicle_info'] as String,
      services: List<String>.from(json['services'] ?? []),
      requestedDateTime: DateTime.parse(json['requested_at'] as String),
      location: json['location'] as String? ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      estimatedEarnings: (json['estimated_earnings'] as num?)?.toDouble() ?? 0.0,
      status: JobStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => JobStatus.pending,
      ),
      address: json['address'] as String?,
    );
  }
}

enum JobStatus {
  pending,
  accepted,
  inProgress,
  completed,
  cancelled;

  static JobStatus fromString(String status) {
    return JobStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => JobStatus.pending,
    );
  }
}
