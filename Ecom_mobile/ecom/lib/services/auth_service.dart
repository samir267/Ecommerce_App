import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/io_client.dart';
import 'dart:io';

class AuthService {
  final String baseUrl = "https://192.168.1.36:7223/api/User";
  final String baseUrl2 = "https://192.168.1.36:7223/api/Login";
  final FlutterSecureStorage storage = FlutterSecureStorage();

  final HttpClient client = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  
  late final http.Client ioClient = IOClient(client);

  // Inscription
  Future<Map<String, dynamic>> register(Map<String, String> userData) async {
    final url = Uri.parse('$baseUrl/Register');
    try {
      final response = await ioClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur lors de l\'inscription : ${response.body}');
      }
    } catch (e) {
      throw Exception('Une erreur est survenue : $e');
    }
  }

  // Connexion
  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl2/PostLoginDetails');

    try {
      print('Starting login process for email: $email');
      print('Attempting login to URL: $url');

      final response = await ioClient.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Vérifiez si le champ "accessToken" existe
        if (data.containsKey('accessToken')) {
          final token = data['accessToken'];
          await storage.write(key: 'jwt', value: token); // Sauvegarde du token
          print('Login successful. Token saved: $token');
        } else {
          throw Exception('Token not found in response.');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Invalid credentials. Please check your email and password.');
      } else {
        throw Exception('Failed to log in. Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during login request: $e');
      throw Exception('An error occurred: $e');
    }
  }
}
