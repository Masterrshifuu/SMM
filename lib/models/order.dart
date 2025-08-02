import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smm/models/cart_item.dart';
import 'package:smm/models/product.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double totalAmount;
  final Timestamp createdAt;
  final String status;
  final String deliveryAddress;
  final bool active;
  final int extraTimeInMinutes;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.createdAt,
    required this.status,
    required this.deliveryAddress,
    required this.active,
    required this.extraTimeInMinutes,
  });

  factory Order.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    var itemsFromDb = data['items'] as List;
    List<CartItem> items = itemsFromDb.map((itemData) {
      return CartItem(
        id: itemData['id'],
        quantity: itemData['quantity'],
        // The product details are nested, so we create a "dummy" product
        // In a real app, you might fetch full product details separately
        // or ensure they are fully denormalized in the order.
        product: Product(
          id: itemData['id'],
          name: itemData['name'],
          description: '', // Not available in order item
          price: itemData['price'],
          mrp: itemData['mrp'] ?? itemData['price'],
          category: '', // Not available in order item
          imageUrl: itemData['imageUrl'],
          additionalImages: [], // Not available in order item
          isBestseller: false, // Not available in order item
          isAd: false, // Not available in order item
          stock: 0, // Not available in order item
        ),
      );
    }).toList();

    return Order(
      id: doc.id,
      userId: data['userId'] ?? '',
      totalAmount: (data['totalAmount'] ?? 0).toDouble(),
      createdAt: data['createdAt'] ?? Timestamp.now(),
      status: data['status'] ?? 'Pending',
      deliveryAddress: data['deliveryAddress'] ?? '',
      active: data['active'] ?? false,
      extraTimeInMinutes: data['extraTimeInMinutes'] ?? 0,
      items: items,
    );
  }
}