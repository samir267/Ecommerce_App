import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService {
  final String baseUrl = "${dotenv.env['BASE_URL']!}:7223/api/User";
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final HttpClient client = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  
  late final http.Client ioClient = IOClient(client);

  // Récupérer les informations utilisateur par ID
  Future<Map<String, dynamic>> getUser(int userId) async {
    final url = Uri.parse('$baseUrl/$userId');

    try {
      final response = await ioClient.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          // Récupérer le token JWT dans le stockage sécurisé
          'Authorization': 'Bearer ${await storage.read(key: 'jwt')}'
        },
      );

      if (response.statusCode == 200) {
        // Si la requête est réussie, on renvoie les données de l'utilisateur
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de la récupération de l\'utilisateur : ${response.body}');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue lors de la requête : $e');
    }
  }

  // Mettre à jour les informations de l'utilisateur
  Future<Map<String, dynamic>> updateUser(int userId, Map<String, String> userData) async {
    final url = Uri.parse('$baseUrl/$userId');

    try {
      final response = await ioClient.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          // 'Authorization': 'Bearer ${await storage.read(key: 'jwt')}'
        },
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        // Si la requête est réussie, on renvoie les données mises à jour
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de la mise à jour de l\'utilisateur : ${response.body}');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue lors de la requête : $e');
    }
  }
}
