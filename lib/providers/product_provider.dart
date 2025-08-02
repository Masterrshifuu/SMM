import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smm/models/product.dart';
import 'package:smm/models/category.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Product> _products = [];
  List<Category> _categories = [];
  bool _isLoading = false;

  StreamSubscription<QuerySnapshot>? _productsSubscription;
  StreamSubscription<QuerySnapshot>? _categoriesSubscription;

  List<Product> get products => _products.where((p) => p.stock > 0).toList();
  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  ProductProvider() {
    listenToProducts();
    listenToCategories();
  }

  void listenToProducts() {
    _isLoading = true;
    notifyListeners();

    _productsSubscription?.cancel();
    _productsSubscription =
        _firestore.collection('products').snapshots().listen((snapshot) {
      _products =
          snapshot.docs.map((doc) => Product.fromFirestore(doc)).toList();
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      foundation.debugPrint("Error listening to products: $error");
      _isLoading = false;
      notifyListeners();
    });
  }

  void listenToCategories() {
    _categoriesSubscription?.cancel();
    _categoriesSubscription =
        _firestore.collection('categories').snapshots().listen((snapshot) {
      _categories =
          snapshot.docs.map((doc) => Category.fromFirestore(doc)).toList();
      notifyListeners();
    }, onError: (error) {
       foundation.debugPrint("Error listening to categories: $error");
    });
  }

  List<Product> get bestsellers {
    return products.where((p) => p.isBestseller).toList();
  }

  @override
  void dispose() {
    _productsSubscription?.cancel();
    _categoriesSubscription?.cancel();
    super.dispose();
  }
}