import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../models/order_model.dart';
import '../../trackOrder/delivery_tracking_screen.dart';

class ActionButtons extends StatelessWidget {
  final OrderModel order;

  const ActionButtons({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildButton(context, Icons.call, "Call", () {
          launchUrl(Uri.parse("tel:1234567890"));
        }),
        const SizedBox(width: 12),
        _buildButton(context, Icons.navigation, "Navigate", () {
          final url = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=${order.latitude},${order.longitude}");
          launchUrl(url, mode: LaunchMode.externalApplication);
        }),
        const SizedBox(width: 12),
        _buildButton(context, Icons.location_on, "Track", () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeliveryTrackingPage(
                deliveryAddress: LatLng(order.latitude, order.longitude),
                orderId: order.id,
                customerName: order.customerName,
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
