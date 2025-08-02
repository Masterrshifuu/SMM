import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:smm/models/order.dart';
import 'package:smm/models/cart_item.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Order> _orders = [];
  bool _isLoading = false;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;

  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final snapshot = await _firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      _orders = snapshot.docs.map((doc) => Order.fromFirestore(doc)).toList();
    } catch (e) {
      // Handle error
    }
    _isLoading = false;
    notifyListeners();
  }

    Future<void> placeOrder(List<CartItem> cartItems, double total, String userId, String address) async {
    _isLoading = true;
    notifyListeners();
    final timeStamp = Timestamp.now();
    try {
      await _firestore.collection('orders').add({
        'userId': userId,
        'totalAmount': total,
        'createdAt': timeStamp,
        'deliveryAddress': address,
        'status': 'Pending',
        'active': true,
        'extraTimeInMinutes': 0,
        'items': cartItems
            .map((cp) => {
                  'id': cp.product.id,
                  'name': cp.product.name,
                  'quantity': cp.quantity,
                  'price': cp.product.price,
                  'imageUrl': cp.product.imageUrl,
                })
            .toList(),
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
       _isLoading = false;
       notifyListeners();
       rethrow;
    }
  }
}