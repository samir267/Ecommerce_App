import 'package:flutter/material.dart';
import 'package:ecom/sqlite/UserDatabase.dart';
import 'package:ecom/services/order_service.dart';

class HistoricOrders extends StatefulWidget {
  const HistoricOrders({Key? key}) : super(key: key);

  @override
  _HistoricOrdersState createState() => _HistoricOrdersState();
}

class _HistoricOrdersState extends State<HistoricOrders> {
  late UserDatabase database;
  late OrderService orderService;
  String userId = '';
  bool isLoading = true;
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    database = UserDatabase();
    orderService = OrderService();
    _getUser();
  }

  Future<void> _getUser() async {
    try {
      final userMap = await database.getUser();
      if (userMap != null && userMap.isNotEmpty) {
        setState(() {
          userId = userMap['userId'].toString();
        });
        await _fetchOrders(int.parse(userId));
      } else {
        setState(() {
          userId = 'No user found';
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error retrieving user: $e');
      setState(() {
        userId = 'Error retrieving user';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchOrders(int userId) async {
    try {
      final fetchedOrders = await orderService.getOrders(userId);
      setState(() {
        orders = fetchedOrders;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          "Historic Orders",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : orders.isEmpty
              ? const Center(child: Text("No orders found"))
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: Text("Order ID: ${order['orderId']}"),
                            subtitle: Text("Total: ${order['totalAmount']}"),
                          ),
                          const Divider(),
                          ...order['products'].map<Widget>((product) {
                            return ListTile(
                              title: Text(product['productName']),
                              subtitle: Text("Price: \$${product['productPrice']}"),
                              leading: Image.network(product['productImage']),
                            );
                          }).toList(),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
