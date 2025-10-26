import 'package:flutter/material.dart';
import '../models/Products_model.dart';

class OrderItem {
  final Products product;
  final int quantity;
  final double price;

  OrderItem({
    required this.product,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      product: Products.fromJson(map['product']),
      quantity: map['quantity'] ?? 1,
      price: (map['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product': {
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'category': product.category,
        'image': product.image,
        'stock': product.stock,
        'rating': product.rating,
      },
      'quantity': quantity,
      'price': price,
    };
  }
}

class Order {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final String? shippingAddress;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? trackingNumber;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    this.shippingAddress,
    required this.createdAt,
    this.updatedAt,
    this.trackingNumber,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromMap(item))
          .toList() ?? [],
      totalAmount: (map['totalAmount'] as num).toDouble(),
      status: map['status'] ?? 'pending',
      paymentMethod: map['paymentMethod'] ?? 'card',
      shippingAddress: map['shippingAddress'],
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      trackingNumber: map['trackingNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'trackingNumber': trackingNumber,
    };
  }

  Order copyWith({
    String? status,
    DateTime? updatedAt,
    String? trackingNumber,
  }) {
    return Order(
      id: id,
      userId: userId,
      items: items,
      totalAmount: totalAmount,
      status: status ?? this.status,
      paymentMethod: paymentMethod,
      shippingAddress: shippingAddress,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }
}

class OrdersProvider extends ChangeNotifier {
  List<Order> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get orders by status
  List<Order> getOrdersByStatus(String status) {
    return _orders.where((order) => order.status.toLowerCase() == status.toLowerCase()).toList();
  }

  // Get pending orders
  List<Order> get pendingOrders => getOrdersByStatus('pending');

  // Get confirmed orders
  List<Order> get confirmedOrders => getOrdersByStatus('confirmed');

  // Get shipped orders
  List<Order> get shippedOrders => getOrdersByStatus('shipped');

  // Get delivered orders
  List<Order> get deliveredOrders => getOrdersByStatus('delivered');

  // Get cancelled orders
  List<Order> get cancelledOrders => getOrdersByStatus('cancelled');

  // Create order from cart items
  Future<bool> createOrder({
    required String userId,
    required List<OrderItem> items,
    required String paymentMethod,
    String? shippingAddress,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // await FirebaseFirestore.instance.collection('orders').add(orderData);

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      final totalAmount = items.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity));

      final order = Order(
        id: 'order_${DateTime.now().millisecondsSinceEpoch}',
        userId: userId,
        items: items,
        totalAmount: totalAmount,
        status: 'pending',
        paymentMethod: paymentMethod,
        shippingAddress: shippingAddress,
        createdAt: DateTime.now(),
      );

      _orders.insert(0, order); // Add to beginning of list
      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to create order: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Update order status
  Future<bool> updateOrderStatus({
    required String orderId,
    required String status,
    String? trackingNumber,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // await FirebaseFirestore.instance
      //     .collection('orders')
      //     .doc(orderId)
      //     .update({
      //   'status': status,
      //   'updatedAt': DateTime.now().toIso8601String(),
      //   if (trackingNumber != null) 'trackingNumber': trackingNumber,
      // });

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      final orderIndex = _orders.indexWhere((order) => order.id == orderId);
      if (orderIndex != -1) {
        _orders[orderIndex] = _orders[orderIndex].copyWith(
          status: status,
          updatedAt: DateTime.now(),
          trackingNumber: trackingNumber,
        );
      }

      _setLoading(false);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Failed to update order: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(
      orderId: orderId,
      status: 'cancelled',
    );
  }

  // Load user orders
  Future<void> loadUserOrders(String userId) async {
    try {
      _setLoading(true);
      _clearError();

      // TODO: Replace with Firebase Firestore
      // final snapshot = await FirebaseFirestore.instance
      //     .collection('orders')
      //     .where('userId', isEqualTo: userId)
      //     .orderBy('createdAt', descending: true)
      //     .get();
      // 
      // _orders = snapshot.docs
      //     .map((doc) => Order.fromMap(doc.data()))
      //     .toList();

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));

      // Add some sample orders for demo
      if (_orders.isEmpty) {
        _orders = _generateSampleOrders(userId);
      }

      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to load orders: ${e.toString()}');
      _setLoading(false);
    }
  }

  // Get order by ID
  Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get order statistics
  Map<String, int> getOrderStatistics() {
    return {
      'total': _orders.length,
      'pending': pendingOrders.length,
      'confirmed': confirmedOrders.length,
      'shipped': shippedOrders.length,
      'delivered': deliveredOrders.length,
      'cancelled': cancelledOrders.length,
    };
  }

  // Generate sample orders for demo
  List<Order> _generateSampleOrders(String userId) {
    final sampleProducts = [
      Products(
        id: 1,
        name: 'Sample Product 1',
        description: 'A great product',
        price: 29.99,
        category: 'Electronics',
        image: 'sample1.jpg',
        stock: 10,
        rating: 4.5,
      ),
      Products(
        id: 2,
        name: 'Sample Product 2',
        description: 'Another great product',
        price: 49.99,
        category: 'Clothing',
        image: 'sample2.jpg',
        stock: 5,
        rating: 4.2,
      ),
    ];

    return [
      Order(
        id: 'order_1',
        userId: userId,
        items: [
          OrderItem(
            product: sampleProducts[0],
            quantity: 2,
            price: sampleProducts[0].price,
          ),
        ],
        totalAmount: 59.98,
        status: 'delivered',
        paymentMethod: 'card',
        shippingAddress: '123 Main St, City, Country',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        trackingNumber: 'TRK123456789',
      ),
      Order(
        id: 'order_2',
        userId: userId,
        items: [
          OrderItem(
            product: sampleProducts[1],
            quantity: 1,
            price: sampleProducts[1].price,
          ),
        ],
        totalAmount: 49.99,
        status: 'shipped',
        paymentMethod: 'paypal',
        shippingAddress: '456 Oak Ave, City, Country',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        updatedAt: DateTime.now().subtract(const Duration(hours: 12)),
        trackingNumber: 'TRK987654321',
      ),
      Order(
        id: 'order_3',
        userId: userId,
        items: [
          OrderItem(
            product: sampleProducts[0],
            quantity: 1,
            price: sampleProducts[0].price,
          ),
          OrderItem(
            product: sampleProducts[1],
            quantity: 1,
            price: sampleProducts[1].price,
          ),
        ],
        totalAmount: 79.98,
        status: 'pending',
        paymentMethod: 'card',
        shippingAddress: '789 Pine St, City, Country',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ];
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
