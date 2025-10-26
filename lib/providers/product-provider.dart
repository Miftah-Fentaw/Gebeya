import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/Products_model.dart';
import 'package:flutter/services.dart';


class ProductProvider extends ChangeNotifier {


  List<Products> _allProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = true;

  List<Products> get allProducts => _allProducts;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  bool get isLoading => _isLoading;

  ProductProvider() {
    loadAllProducts();
  }

  Future<void> loadAllProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('assets/JSONS/All.json');
      final List<dynamic> jsonData = json.decode(jsonString) as List<dynamic>;
      _allProducts = jsonData
          .map((e) => Products.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      _allProducts = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    _searchQuery = ''; 
    notifyListeners();
  }

  void setSearchQuery(String query) {
    try {
      _searchQuery = query.trim().toLowerCase();
      notifyListeners();
    } catch (e) {
      print('Error setting search query: $e');
      _searchQuery = '';
      notifyListeners();
    }
  }

  List<Products> get displayedProducts {
    try {
      if (_searchQuery.isNotEmpty) {
        // smart search across all products
        return _allProducts.where((p) {
          try {
            final name = p.name.toLowerCase();
            final description = p.description.toLowerCase();
            final categoryLower = p.category.toLowerCase();
            return name.contains(_searchQuery) ||
                description.contains(_searchQuery) ||
                categoryLower.contains(_searchQuery);
          } catch (e) {
            print('Error filtering product: $e');
            return false;
          }
        }).toList();
      }

      // no search -> filter by category
      if (_selectedCategory.toLowerCase() == 'all') return _allProducts;
      return _allProducts
          .where((p) {
            try {
              return p.category.toLowerCase() ==
                  _selectedCategory.toLowerCase();
            } catch (e) {
              print('Error filtering by category: $e');
              return false;
            }
          })
          .toList();
    } catch (e) {
      print('Error in displayedProducts: $e');
      return [];
    }
  }

  void loadProducts(String categoryName) {
    setCategory(categoryName);
  }
}
