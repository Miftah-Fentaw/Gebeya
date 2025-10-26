import 'package:gebeya/constants/Colors.dart';
import 'package:gebeya/providers/orders_provider.dart';
import 'package:gebeya/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    
    // Load user orders when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      if (authProvider.user != null) {
        Provider.of<OrdersProvider>(context, listen: false)
            .loadUserOrders(authProvider.user!.id);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<OrdersProvider, AuthProvider>(
      builder: (context, ordersProvider, authProvider, child) {
        final stats = ordersProvider.getOrderStatistics();
        
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primaryColor, secondaryColor],
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.07, // Responsive top padding
                    left: MediaQuery.of(context).size.width * 0.05, // Responsive left padding
                    right: MediaQuery.of(context).size.width * 0.05, // Responsive right padding
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Your Orders',
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.08, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: black,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${stats['total']} Total',
                          style: TextStyle(
                            color: black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025), // Responsive spacing
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: black,
                  labelColor: black,
                  unselectedLabelColor: black.withOpacity(0.6),
                  tabs: [
                    Tab(text: 'All (${stats['total']})'),
                    Tab(text: 'Pending (${stats['pending']})'),
                    Tab(text: 'Confirmed (${stats['confirmed']})'),
                    Tab(text: 'Shipped (${stats['shipped']})'),
                    Tab(text: 'Delivered (${stats['delivered']})'),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrdersList(ordersProvider.orders),
                      _buildOrdersList(ordersProvider.pendingOrders),
                      _buildOrdersList(ordersProvider.confirmedOrders),
                      _buildOrdersList(ordersProvider.shippedOrders),
                      _buildOrdersList(ordersProvider.deliveredOrders),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrdersList(List orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: MediaQuery.of(context).size.width * 0.25, // Responsive icon size
              color: Colors.grey[400],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.025), // Responsive spacing
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.06, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.0125), // Responsive spacing
            Text(
              'Your orders will appear here',
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05), // Responsive padding
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(order) {
    return Container(
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.02), // Responsive margin
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04), // Responsive padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id.substring(order.id.length - 8)}',
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.04, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.02, // Responsive horizontal padding
                  vertical: MediaQuery.of(context).size.height * 0.005, // Responsive vertical padding
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  order.status.toUpperCase(),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(order.status),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0125), // Responsive spacing
          Text(
            '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.035, // Responsive font size
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.0125), // Responsive spacing
          Row(
            children: [
              Expanded(
                child: Text(
                  'Total: \$${order.totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.045, // Responsive font size
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              Text(
                _formatDate(order.createdAt),
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03, // Responsive font size
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          if (order.trackingNumber != null) ...[
            SizedBox(height: MediaQuery.of(context).size.height * 0.0125), // Responsive spacing
            Row(
              children: [
                Icon(Icons.local_shipping, size: MediaQuery.of(context).size.width * 0.04, color: Colors.blue), // Responsive icon size
                SizedBox(width: MediaQuery.of(context).size.width * 0.0125), // Responsive spacing
                Text(
                  'Tracking: ${order.trackingNumber}',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.03, // Responsive font size
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: MediaQuery.of(context).size.height * 0.02), // Responsive spacing
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showOrderDetails(order),
                  child: Text('View Details'),
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.025), // Responsive spacing
              if (order.status == 'pending')
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () => _cancelOrder(order),
                    child: Text('Cancel'),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'shipped':
        return Colors.purple;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  void _showOrderDetails(order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details'),
        content: SizedBox(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.5, // Responsive height
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: ${order.id}'),
                Text('Status: ${order.status.toUpperCase()}'),
                Text('Payment: ${order.paymentMethod}'),
                Text('Date: ${order.createdAt.toString().split(' ')[0]}'),
                if (order.shippingAddress != null)
                  Text('Address: ${order.shippingAddress}'),
                SizedBox(height: MediaQuery.of(context).size.height * 0.025), // Responsive spacing
                Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...order.items.map<Widget>((item) => Padding(
                  padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.005), // Responsive padding
                  child: Row(
                    children: [
                      Expanded(
                        child: Text('${item.product.name} x${item.quantity}'),
                      ),
                      Text('\$${(item.price * item.quantity).toStringAsFixed(2)}'),
                    ],
                  ),
                )).toList(),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${order.totalAmount.toStringAsFixed(2)}', 
                         style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _cancelOrder(order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Order'),
        content: Text('Are you sure you want to cancel this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await Provider.of<OrdersProvider>(context, listen: false)
                  .cancelOrder(order.id);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(success ? 'Order cancelled' : 'Failed to cancel order'),
                    backgroundColor: success ? Colors.green : Colors.red,
                  ),
                );
              }
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}