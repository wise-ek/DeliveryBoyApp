import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import 'widgets/action_buttons.dart';
import 'widgets/delivery_button.dart';
import 'widgets/info_card.dart';
import 'widgets/map_section.dart';
import 'widgets/product_list.dart';


class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Order Details"),
        centerTitle: true,
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          InfoCard(order: order),
          const SizedBox(height: 16),
          ProductList(order: order),
          const SizedBox(height: 16),
          MapSection(order: order),
          const SizedBox(height: 16),
          ActionButtons(order: order),
          const SizedBox(height: 20),
          DeliveryButton(order: order),
        ],
      ),
    );
  }
}
