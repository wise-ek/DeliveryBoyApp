import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final String id;
  final String customerName;
  final String address;
  final String deliveryTime;
  final double distanceKm;
  final List<String> products;
  final double latitude;
  final double longitude;
  bool isDelivered;

  OrderModel({
    required this.id,
    required this.customerName,
    required this.address,
    required this.deliveryTime,
    required this.distanceKm,
    required this.products,
    required this.latitude,
    required this.longitude,
    this.isDelivered = false,
  });

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      customerName: map['customerName'] ?? '',
      address: map['address'] ?? '',
      deliveryTime: map['deliveryTime'] ?? '',
      distanceKm: (map['distanceKm'] ?? 0).toDouble(),
      products: List<String>.from(map['products'] ?? []),
      latitude: (map['latitude'] ?? 0).toDouble(),
      longitude: (map['longitude'] ?? 0).toDouble(),
      isDelivered: map['isDelivered'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerName': customerName,
      'address': address,
      'deliveryTime': deliveryTime,
      'distanceKm': distanceKm,
      'products': products,
      'latitude': latitude,
      'longitude': longitude,
      'isDelivered': isDelivered,
    };
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel.fromMap({
      ...data,
      'id': doc.id, // Use Firestore document ID as the ID
    });
  }
}
