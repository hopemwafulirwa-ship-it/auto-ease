import 'package:auto_ease/src/features/home/domain/service_center_model.dart';

const List<ServiceCenter> kMockServiceCenters = [
  ServiceCenter(
    id: '1',
    name: 'AutoFix Pro Center',
    address: '123 Mechanic St, Auto City',
    latitude: 37.7749,
    longitude: -122.4194,
    rating: 4.8,
    reviewCount: 124,
    distance: 1.2,
    isOpen: true,
    services: ['Oil Change', 'Brake Repair', 'Tire Rotation'],
    imageUrl:
        'https://images.unsplash.com/photo-1625047509168-a7026f36de04?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  ServiceCenter(
    id: '2',
    name: 'Quick Lube & Tune',
    address: '456 Engine Ave, Motor Town',
    latitude: 37.7849,
    longitude: -122.4094,
    rating: 4.2,
    reviewCount: 89,
    distance: 2.5,
    isOpen: true,
    services: ['Oil Change', 'Inspection'],
    imageUrl:
        'https://images.unsplash.com/photo-1487754180451-c456f719a1fc?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  ServiceCenter(
    id: '3',
    name: 'Premium Auto Care',
    address: '789 Luxury Ln, Carville',
    latitude: 37.7649,
    longitude: -122.4294,
    rating: 4.9,
    reviewCount: 210,
    distance: 3.8,
    isOpen: false,
    services: ['Detailing', 'Engine Repair', 'Body Work'],
    imageUrl:
        'https://images.unsplash.com/photo-1597762470488-387751f538c6?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
  ServiceCenter(
    id: '4',
    name: 'Budget Brakes',
    address: '101 Economy Blvd, Thrift City',
    latitude: 37.7549,
    longitude: -122.4394,
    rating: 3.8,
    reviewCount: 45,
    distance: 5.0,
    isOpen: true,
    services: ['Brake Repair', 'Suspension'],
    imageUrl:
        'https://images.unsplash.com/photo-1504222490245-4367b8b971c0?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3',
  ),
];
