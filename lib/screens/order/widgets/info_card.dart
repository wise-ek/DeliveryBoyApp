import 'package:flutter/material.dart';
import '../../../models/order_model.dart';

class InfoCard extends StatelessWidget {
  final OrderModel order;

  const InfoCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _boxDecoration(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow(Icons.tag, "Order ID", order.id),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.person, "Customer", order.customerName),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.home, "Address", order.address),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.access_time, "Delivery Time", order.deliveryTime),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.location_on, "Distance", "${order.distanceKm.toStringAsFixed(1)} km"),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[700]),
        const SizedBox(width: 8),
        Text("$title:", style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(width: 4),
        Expanded(child: Text(value, style: const TextStyle(color: Colors.black87))),
      ],
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.15),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
