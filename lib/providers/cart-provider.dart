import 'package:flutter/material.dart';
import '../models/Products_model.dart';

class CartProvider extends ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  void addToCart(Products product) {
    if (_items.containsKey(product.id)) {
      _items[product.id]!.quantity += 1;
    } else {
      _items[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  void updateQuantity(Products product, int newQuantity) {
    if (_items.containsKey(product.id)) {
      if (newQuantity <= 0) {
        _items.remove(product.id);
      } else {
        _items[product.id]!.quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  void removeFromCart(Products product) {
    if (_items.containsKey(product.id)) {
      _items.remove(product.id);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
}

class CartItem {
  final Products product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}
