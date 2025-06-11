import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/order_model.dart';
import '../../../providers/order_provider.dart';

class DeliveryButton extends StatelessWidget {
  final OrderModel order;

  const DeliveryButton({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    if (!order.isDelivered) {
      return ElevatedButton.icon(
        onPressed: () {
          Provider.of<OrderProvider>(context, listen: false).markAsDelivered(order.id);
          Navigator.pop(context);
        },
        icon: const Icon(Icons.check),
        label: const Text("Mark as Delivered"),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } else {
      return const Text(
        "This order is already delivered.",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      );
    }
  }
}
