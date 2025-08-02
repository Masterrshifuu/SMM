import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final double mrp;
  final String category;
  final String imageUrl;
  final List<String> additionalImages;
  final bool isBestseller;
  final bool isAd;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.mrp,
    required this.category,
    required this.imageUrl,
    required this.additionalImages,
    required this.isBestseller,
    required this.isAd,
    required this.stock,
  });

  factory Product.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      mrp: (data['mrp'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      additionalImages: List<String>.from(data['additionalImages'] ?? []),
      isBestseller: data['isBestseller'] ?? false,
      isAd: data['isAd'] ?? false,
      stock: data['stock'] ?? 0,
    );
  }
}