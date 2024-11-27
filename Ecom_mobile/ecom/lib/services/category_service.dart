import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:ecom/models/categorie_model.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CategoryService {
  late final IOClient _client;
  final String _baseUrl = "${dotenv.env['BASE_URL']!}:7223/api/Category";

  CategoryService() {
    final HttpClient _httpClient = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    _client = IOClient(_httpClient); 
  }

Future<List<Category>> fetchCategories() async {
  try {
    final response = await _client.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> decodedResponse = json.decode(response.body);

      
        final List<dynamic> data = decodedResponse['\$values'];
        return data.map((json) => Category.fromJson(json)).toList();
      
    } else {
      throw Exception('Échec de la récupération des catégories. Status: ${response.statusCode}');
    }
  } catch (error) {
    print("Erreur dans la requête HTTP: $error");
    rethrow;
  }
}



  void close() {
    _client.close();
  }
}
