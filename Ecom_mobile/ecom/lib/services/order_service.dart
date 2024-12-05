import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';
import 'package:http/io_client.dart';

class OrderService {
  late final IOClient _client;

  OrderService() {
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    _client = IOClient(httpClient);
  }

  /// Crée une commande avec les informations fournies
  Future<void> createOrder({
    required String userId,
    required String address,
    required String paymentMethod,
    required double subtotal,
  }) async {
    // Construire l'URL de l'API à partir de la variable d'environnement
    final url = Uri.parse('${dotenv.env['BASE_URL']!}:7223/api/Order/create');

    // Préparer le corps de la requête
    final body = {
      "userId": userId,
      "shippingAddress": address, // Correctement passé l'adresse
      "paymentMethod": paymentMethod, // Correctement passé la méthode de paiement
      "subtotal": subtotal
    };

    try {
      // Envoyer la requête POST
      final response = await _client.post(
        url,
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      // Vérifier le statut de la réponse
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Order created successfully: ${response.body}');
      } else {
        print('Failed to create order: StatusCode = ${response.statusCode}, Body = ${response.body}');
        throw Exception('Failed to create order');
      }
    } catch (error) {
      // Gérer les erreurs de connexion ou autres exceptions
      print('Error creating order: $error');
      rethrow; // Optionnel : pour permettre au code appelant de gérer l'erreur
    }
  }
  

  Future<void> deleteUserCart(int userId) async {
    final url = Uri.parse('${dotenv.env['BASE_URL']!}:7223/api/Cart/clear/$userId');

    try {
      final response = await _client.delete(url);

      if (response.statusCode == 200) { 
        print('Cart deleted successfully: ${response.body}');
      } else {
        print('Failed to delete cart: StatusCode = ${response.statusCode}, Body = ${response.body}');
        throw Exception('Failed to delete cart');
      }
    } catch (error) {
      print('Error deleting cart: $error');
    }
  }



  Future<List<Map<String, dynamic>>> getOrders(int userId) async {
  final url = Uri.parse('${dotenv.env['BASE_URL']!}:7223/api/Order/get-orders/$userId');

  try {
    final response = await _client.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> orders = data['\$values'];
      
      return orders.map((order) {
        // Récupération des informations de la commande
        final orderData = order as Map<String, dynamic>;
        final orderId = orderData['orderId'];
        final totalAmount = orderData['totalAmount'];
        final orderDate = orderData['orderDate'];
        final orderStatus = orderData['orderStatus'];
        final shippingAddress = orderData['shippingAddress'];
        final paymentMethod = orderData['paymentMethod'];
        final paymentStatus = orderData['paymentStatus'];

        // Récupération des produits associés à la commande
        final products = (orderData['products']['\$values'] as List)
            .map((product) {
              final productData = product as Map<String, dynamic>;
              return {
                'productId': productData['productId'],
                'productName': productData['productName'],
                'productPrice': productData['productPrice'],
                'productDescription': productData['productDescription'],
                'productImage': productData['prudctImage'],
                'quantity': productData['quantity'],
                'totalPrice': productData['totalPrice'],
              };
            })
            .toList();

        return {
          'orderId': orderId,
          'orderDate': orderDate,
          'totalAmount': totalAmount,
          'orderStatus': orderStatus,
          'shippingAddress': shippingAddress,
          'paymentMethod': paymentMethod,
          'paymentStatus': paymentStatus,
          'products': products,
        };
      }).toList();
    } else {
      print('Failed to fetch orders: StatusCode = ${response.statusCode}, Body = ${response.body}');
      throw Exception('Failed to fetch orders');
    }
  } catch (error) {
    print('Error fetching orders: $error');
    rethrow;
  }
}


  /// Ferme le client HTTP
  void close() {
    _client.close();
  }
}
