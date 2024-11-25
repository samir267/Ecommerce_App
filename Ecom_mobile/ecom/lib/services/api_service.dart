import 'package:dio/dio.dart';
import 'package:ecom/models/user_model.dart';
import 'package:logger/logger.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.36:5265/api',
    headers: {'Content-Type': 'application/json'},
  ));
  final Logger _logger = Logger(); // Initialisez le logger

  // Méthode pour l'enregistrement de l'utilisateur
  Future<UserModel?> registerUser(UserModel user) async {
    try {
      final response = await _dio.post('/user/register', data: user.toJson());

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(response.data);
      } else {
        String errorMessage = _getErrorMessage(response);
        throw Exception('Échec de l\'enregistrement de l\'utilisateur : $errorMessage');
      }
    } on DioException catch (e) {
      _logger.e('Erreur d\'enregistrement : ${e.message}'); // Utilisez logger
      throw Exception('Erreur réseau : ${e.message}');
    }
  }

  // Méthode pour la connexion de l'utilisateur
  Future<UserModel?> loginUser(String email, String password) async {
    try {
      final response = await _dio.post('/login/PostLoginDetails', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        String errorMessage = _getErrorMessage(response);
        throw Exception('Échec de la connexion de l\'utilisateur : $errorMessage');
      }
    } on DioException catch (e) {
      _logger.e('Erreur de connexion : ${e.message}'); // Utilisez logger
      throw Exception('Erreur réseau : ${e.message}');
    }
  }

  // Méthode pour obtenir le message d'erreur de la réponse
  String _getErrorMessage(Response response) {
    try {
      final Map<String, dynamic> errorResponse = response.data;
      return errorResponse['message'] ?? response.statusMessage ?? 'Une erreur inconnue s\'est produite';
    } catch (e) {
      return response.statusMessage ?? 'Une erreur inconnue s\'est produite';
    }
  }
}
