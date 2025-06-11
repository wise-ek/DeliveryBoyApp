import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderProvider with ChangeNotifier {
  // Private list to hold all fetched orders
  List<OrderModel> _orders = [];

  // Public getter to access orders
  List<OrderModel> get orders => _orders;

  /// Start listening to real-time updates from Firestore 'orders' collection
  /// Call this in SplashScreen or main() to keep data updated live
  void listenToOrders(String uid) {
    print(uid.toString()+"sdfkdslkn");
    FirebaseFirestore.instance.collection('orders').where("boyUid",isEqualTo:uid ).snapshots().listen((snapshot) {
      _orders = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
      notifyListeners(); // Notify listeners for UI rebuild
    });
  }

  /// Fetch all orders from Firestore once (not real-time)
  Future<void> fetchOrders() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('orders').get();
      _orders = snapshot.docs.map((doc) => OrderModel.fromMap(doc.data())).toList();
      notifyListeners(); // Update UI after fetching
    } catch (e) {
      print('Error fetching orders: $e');
    }
  }

  /// Mark a specific order as delivered both locally and in Firestore
  void markAsDelivered(String orderId) {
    final index = _orders.indexWhere((order) => order.id == orderId);
    if (index != -1) {
      _orders[index].isDelivered = true;
      notifyListeners(); // Update UI immediately

      // Update order in Firestore
      FirebaseFirestore.instance.collection('orders').doc(orderId).update({
        'isDelivered': true,
      });
    }
  }

  // Count of all orders
  int get allCount => _orders.length;

  // Count of pending orders (not delivered)
  int get pendingCount => _orders.where((o) => !o.isDelivered).length;

  // Count of delivered orders
  int get deliveredCount => _orders.where((o) => o.isDelivered).length;

  /// Filter orders by status and optionally by search ID
  ///
  /// If [searchId] is provided, it will return orders that match the ID pattern.
  /// Otherwise, it filters by [status] (All, Pending, Delivered).
  List<OrderModel> filterOrders(String status, String searchId) {
    List<OrderModel> result = _orders;

    if (searchId.isNotEmpty) {
      result = result.where((o) => o.id.toLowerCase().contains(searchId.toLowerCase())).toList();
    } else {
      if (status == 'Pending') {
        result = result.where((o) => !o.isDelivered).toList();
      } else if (status == 'Delivered') {
        result = result.where((o) => o.isDelivered).toList();
      }
    }

    return result;
  }
}
