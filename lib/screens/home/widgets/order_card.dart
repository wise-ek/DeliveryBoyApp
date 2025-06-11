import 'package:flutter/material.dart';
import '../../../../models/order_model.dart';
import '../../order/order_details_screen.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final int index;

  const OrderCard({super.key, required this.order, required this.index});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailsScreen(order: order)),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: Colors.deepOrange,
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(order.address, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Text("Delivery: ${order.deliveryTime}", style: const TextStyle(fontSize: 12)),
                    Text(
                      order.isDelivered
                          ? "Delivered to ${order.customerName}"
                          : "Pending for ${order.customerName}",
                      style: TextStyle(
                        color: order.isDelivered ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Chip(
                label: Text(order.isDelivered ? "Delivered" : "Pending"),
                backgroundColor: order.isDelivered ? Colors.green : Colors.orange,
                labelStyle: const TextStyle(color: Colors.white, fontSize: 11),
              )
            ],
          ),
        ),
      ),
    );
  }
}
