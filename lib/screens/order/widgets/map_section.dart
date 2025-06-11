import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../models/order_model.dart';

class MapSection extends StatelessWidget {
  final OrderModel order;

  const MapSection({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Customer Location", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            height: 200,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(order.latitude, order.longitude),
                zoom: 15,
              ),
              markers: {
                Marker(
                  markerId: MarkerId(order.id),
                  position: LatLng(order.latitude, order.longitude),
                  infoWindow: InfoWindow(title: order.customerName),
                ),
              },
            ),
          ),
        ),
      ],
    );
  }
}
