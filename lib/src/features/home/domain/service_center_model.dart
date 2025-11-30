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
}
