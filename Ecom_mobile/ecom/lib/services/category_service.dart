import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'dart:io'; // Importez pour accéder à HttpClient et X509Certificate
import 'package:ecom/models/categorie_model.dart';  // Assurez-vous d'importer le modèle Category

class CategoryService {
  final String _baseUrl = 'https://192.168.1.36:7223/api/Category';

  // Créez un HttpClient avec une callback pour ignorer les erreurs de certificat
  final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  // Utilisez IOClient pour faire des requêtes avec le HttpClient personnalisé
  final IOClient _client;

  CategoryService() : _client = IOClient(HttpClient());

  // Méthode pour récupérer les catégories
  Future<List<Category>> fetchCategories() async {
    try {
      final response = await _client.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Échec de la récupération des catégories');
      }
    } catch (error) {
      throw Exception('Erreur lors de la requête HTTP: $error');
    }
  }

  // N'oubliez pas de fermer le client quand il n'est plus utilisé
  void close() {
    _client.close();
  }
}
