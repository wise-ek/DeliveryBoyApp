import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider with ChangeNotifier {
  // User information
  String phoneNumber = '';
  String uid = '';
  String name = '';
  String _storedOtp = '';
  String _otp = '';

  // Controllers for form input
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  // Authentication and state variables
  bool _isOtpSent = false;
  bool _isLoading = false;
  String _errorMessage = '';
  String? _token;
  bool _isEditing = false;

  // Getters
  bool get isOtpSent => _isOtpSent;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get token => _token;
  bool get isEditing => _isEditing;

  /// Toggle editing mode (used in profile screen)
  void toggleEditMode() {
    _isEditing = !_isEditing;
    notifyListeners();
  }

  /// Update phone number and fetch user data from Firestore
  Future<void> updatePhoneNumber(String value) async {
    phoneNumber = value;
    _errorMessage = '';
    _isOtpSent = false;
    _isLoading = true;
    notifyListeners();

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('boys')
          .where('phone', isEqualTo: phoneNumber)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        name = data['name'] ?? '';
        nameController.text = name;
        phoneController.text = phoneNumber;
        uid = snapshot.docs.first.id;
        _storedOtp = data['otp'] ?? '';
        _isOtpSent = true;
      } else {
        _errorMessage = 'User not found';
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update entered OTP
  void updateOtp(String value) {
    _otp = value;
    notifyListeners();
  }

  /// Verify OTP and save login token if valid
  Future<void> verifyOtp() async {
    if (_otp == _storedOtp) {
      _errorMessage = '';
      _token = 'mock_token_${phoneNumber}_${DateTime.now().millisecondsSinceEpoch}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      await prefs.setString('user_name', name);
      await prefs.setString('user_phone', phoneNumber);
      await prefs.setString('user_id', uid);
    } else {
      _errorMessage = 'Invalid OTP';
    }
    notifyListeners();
  }

  /// Load token from SharedPreferences (used for auto-login)
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    notifyListeners();
  }

  /// Clear all login info and logout user
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Removes all stored data
    _token = null;
    phoneNumber = '';
    uid = '';
    _otp = '';
    _isOtpSent = false;
    _errorMessage = '';
    name = '';
    _storedOtp = '';
    notifyListeners();
  }

  /// Clear token only (without wiping all preferences)
  void clearTokenAfterNavigation() {
    _token = null;
    notifyListeners();
  }

  /// Add a test delivery boy to Firestore (for testing purposes)
  Future<void> addBoy() async {
    try {
      await FirebaseFirestore.instance.collection('boys').add({
        'name': "wise",
        'phone': "9539039327",
        'otp': "123456",
        'created_at': FieldValue.serverTimestamp(),
      });
      print("Boy added successfully!");
    } catch (e) {
      print("Error adding boy: $e");
    }
  }

  /// Add dummy Kerala orders to Firestore (for testing UI)
  Future<void> addKeralaDummyOrdersToFirestore() async {
    final orders = [
      {
        'id': 'ORDKER006',
        'customerName': 'Anjali Menon',
        'address': 'Pattom, Trivandrum',
        'deliveryTime': '9:30 AM',
        'distanceKm': 2.0,
        'products': ['Milk', 'Cornflakes', 'Honey'],
        'latitude': 8.5241,
        'longitude': 76.9366,
        'isDelivered': false,
      },
      {
        'id': 'ORDKER007',
        'customerName': 'Vivek Krishnan',
        'address': 'Palakkad Junction, Palakkad',
        'deliveryTime': '12:00 PM',
        'distanceKm': 3.8,
        'products': ['Eggs', 'Curd', 'Spinach'],
        'latitude': 10.7867,
        'longitude': 76.6548,
        'isDelivered': true,
      },
      {
        'id': 'ORDKER008',
        'customerName': 'Sneha Babu',
        'address': 'Thodupuzha, Idukki',
        'deliveryTime': '1:45 PM',
        'distanceKm': 4.9,
        'products': ['Wheat Flour', 'Green Chilli', 'Soap'],
        'latitude': 9.8975,
        'longitude': 76.7181,
        'isDelivered': false,
      },
      {
        'id': 'ORDKER009',
        'customerName': 'Rakesh Pillai',
        'address': 'Chengannur, Alappuzha',
        'deliveryTime': '3:00 PM',
        'distanceKm': 3.2,
        'products': ['Shampoo', 'Detergent', 'Lemon'],
        'latitude': 9.3251,
        'longitude': 76.6150,
        'isDelivered': true,
      },
      {
        'id': 'ORDKER010',
        'customerName': 'Divya Suresh',
        'address': 'Sulthan Bathery, Wayanad',
        'deliveryTime': '5:30 PM',
        'distanceKm': 6.7,
        'products': ['Coffee', 'Sugar', 'Cookies'],
        'latitude': 11.6591,
        'longitude': 76.2689,
        'isDelivered': false,
      },
    ];

    final ordersRef = FirebaseFirestore.instance.collection('orders');
    for (var order in orders) {
      await ordersRef.doc(order['id'].toString()).set(order);
    }

    print("Kerala dummy orders added successfully");
  }


  Future<void> addFieldToAllDocuments() async {
    final collectionRef = FirebaseFirestore.instance.collection('orders');

    try {
      final querySnapshot = await collectionRef.get();

      for (var doc in querySnapshot.docs) {
        await collectionRef.doc(doc.id).update({
          'boyUid': 'FzLjkg57m2VnC8edgkqx', // Replace with the field name and value you want to add
        });
      }

      print('Field added to all documents successfully.');
    } catch (e) {
      print('Error updating documents: $e');
    }
  }
}
