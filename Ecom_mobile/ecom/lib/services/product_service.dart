  import 'dart:convert';
  import 'dart:io';
  import 'package:http/io_client.dart';
  import 'package:http/http.dart' as http;

  class ProductService {
    Future<Map<String, dynamic>> fetchProducts() async {
      // Créez un client HTTP qui ignore les erreurs SSL
      HttpClient client = HttpClient()
        ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

      IOClient ioClient = IOClient(client);

      final response = await ioClient.get(Uri.parse('https://192.168.1.36:7223/api/Product'));

      if (response.statusCode == 200) {
        // Décodez la réponse JSON
        return json.decode(response.body); // Cette réponse doit être un Map
      } else {
        throw Exception('Échec du chargement des produits');
      }
    }
  }
