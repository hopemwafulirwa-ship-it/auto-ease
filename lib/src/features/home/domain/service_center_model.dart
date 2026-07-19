class ServiceCenter {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final double distance; // In km, calculated dynamically in real app
  final bool isOpen;
  final List<String> services;
  final String imageUrl;

  const ServiceCenter({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.distance,
    required this.isOpen,
    required this.services,
    required this.imageUrl,
  });
  factory ServiceCenter.fromJson(Map<String, dynamic> json) {
    return ServiceCenter(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: json['review_count'] as int,
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      isOpen: json['is_open'] as bool? ?? true,
      services: List<String>.from(json['services'] ?? []),
      imageUrl: json['image_url'] as String? ?? 'https://via.placeholder.com/400x200',
    );
  }
}
