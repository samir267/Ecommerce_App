import 'dart:convert';
import 'dart:io';
import 'package:ecom/models/product_model.dart';
import 'package:http/io_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProductService {
  late final IOClient _client;

  ProductService() {
    // Initialisation d'un client HTTP qui ignore les erreurs SSL
    final HttpClient httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    _client = IOClient(httpClient);
  }

  /// Récupère tous les produits
  Future<Map<String, dynamic>> fetchProducts() async {
    final url = "${dotenv.env['BASE_URL']!}:7223/api/Product";
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        return json.decode(response.body); // Cette réponse doit être un Map
      } else {
        throw Exception('Échec du chargement des produits. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Erreur dans fetchProducts : $error");
      rethrow;
    }
  }

  /// Récupère les produits par catégorie
  Future<List<Product>> fetchProductsByCategory(int categoryId) async {
    final url = "${dotenv.env['BASE_URL']!}:7223/api/Product/category/$categoryId";
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        final Map<String, dynamic> decodedResponse = json.decode(response.body);
        final List<dynamic> data = decodedResponse['\$values'];
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Échec de la récupération des produits. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Erreur dans fetchProductsByCategory : $error");
      rethrow;
    }
  }

  Future<Product> fetchProductById(int id) async {
  final url = "${dotenv.env['BASE_URL']!}:7223/api/Product/$id";
  try {
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Product.fromJson(json.decode(response.body));
    } else {
      throw Exception('Échec de la récupération du produit. Status: ${response.statusCode}');
    }
  } catch (error) {
    print("Erreur dans fetchProductById : $error");
    rethrow;
  }
}


 Future<void> addToCart(int userId, int productId, int quantity) async {
    final url = "${dotenv.env['BASE_URL']!}:7223/api/Cart/add?userId=$userId&productId=$productId&quantity=$quantity";

    try {
      final response = await _client.post(Uri.parse(url));

      if (response.statusCode == 200) {
        // L'ajout au panier a réussi, vous pouvez traiter la réponse si nécessaire
        print("Produit ajouté au panier avec succès.");
      } else {
        throw Exception('Échec de l\'ajout au panier. Status: ${response.statusCode}');
      }
    } catch (error) {
      print("Erreur dans addToCart : $error");
      rethrow;
    }
  }


 Future<Map<String, dynamic>> fetchCartByUserId(int userId) async {
  final url = "${dotenv.env['BASE_URL']!}:7223/api/Cart/user/$userId";

  try {
    final response = await _client.get(Uri.parse(url));

    if (response.statusCode == 200) {
      print("aaa "+ response.body);
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load cart');
  }
   
  } catch (error) {
    print("Erreur dans fetchCartByUserId : $error");
    rethrow;
  }
}


  void close() {
    _client.close();
  }
}
