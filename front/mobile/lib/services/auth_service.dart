import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> login(String phone, String pin) async {
    try {
      final cleanPhone = Helpers.cleanPhoneNumber(phone);
      
      final response = await _apiService.post('/auth/login', data: {
        'phoneNumber': cleanPhone,
        'pin': pin,
      });

      if (response.statusCode == 200 && response.data['success'] == true) {
        // Le backend retourne: { success, message, data: { user, token } }
        final responseData = response.data['data'];
        final token = responseData['token'];
        final user = User.fromJson(responseData['user']);

        await _saveAuthData(token, user);
        _apiService.setAuthToken(token);

        return {'success': true, 'user': user};
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Erreur de connexion'
      };
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau: ${e.toString()}'};
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String pin,
    String? email,
  }) async {
    try {
      final cleanPhone = Helpers.cleanPhoneNumber(phone);
      
      final response = await _apiService.post('/auth/register', data: {
        'name': name,
        'phoneNumber': cleanPhone,
        'pin': pin,
        if (email != null && email.isNotEmpty) 'email': email,
      });

      if (response.statusCode == 201 && response.data['success'] == true) {
        // Le backend retourne: { success, message, data: { user, token } }
        final responseData = response.data['data'];
        final token = responseData['token'];
        final user = User.fromJson(responseData['user']);

        await _saveAuthData(token, user);
        _apiService.setAuthToken(token);

        return {'success': true, 'user': user};
      }

      return {
        'success': false,
        'message': response.data['message'] ?? 'Erreur d\'inscription'
      };
    } catch (e) {
      return {'success': false, 'message': 'Erreur réseau: ${e.toString()}'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.authToken);
    await prefs.remove(StorageKeys.userId);
    _apiService.removeAuthToken();
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(StorageKeys.authToken);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.authToken);
  }

  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.authToken, token);
    await prefs.setString(StorageKeys.userId, user.id);
  }
}
