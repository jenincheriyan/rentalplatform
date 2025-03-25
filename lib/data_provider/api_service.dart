import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://127.0.0.1:3000/api";
  static String? authToken;

  static void setAuthToken(String token) {
    authToken = token;
    print('API Service: Auth token set successfully');
  }

  static Map<String, String> _getAuthHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
      print('Using auth token in headers');
    } else {
      print('Warning: No auth token available for authenticated request');
    }
    return headers;
  }

  static Future<dynamic> registerUser(String email, String password) async {
    try {
      print('Attempting to register user with email: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/user/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Register user status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Register error response: ${response.body}');
        throw Exception('Failed to register user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception during user registration: $e');
      throw Exception('Failed to register user: $e');
    }
  }

  static Future<dynamic> loginUser(String email, String password) async {
    try {
      print('Attempting to login user with email: $email');
      final response = await http.post(
        Uri.parse('$baseUrl/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('Login user status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Save the auth token if it's in the response
        if (data['token'] != null) {
          setAuthToken(data['token']);
        }
        return data;
      } else {
        print('Login error response: ${response.body}');
        throw Exception('Failed to login user: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception during user login: $e');
      throw Exception('Failed to login user: $e');
    }
  }

  static Future<dynamic> fetchRentals() async {
    try {
      print('Attempting to fetch all rentals');
      final response = await http.get(Uri.parse('$baseUrl/rental'));

      print('Fetch rentals status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Fetch rentals error response: ${response.body}');
        throw Exception('Failed to load rentals: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception during fetch rentals: $e');
      throw Exception('Failed to load rentals: $e');
    }
  }

  static Future<dynamic> fetchMyProperties() async {
    try {
      print('Attempting to fetch my properties');
      print('API URL: $baseUrl/user/properties');
      print('Auth token available: ${authToken != null}');

      if (authToken == null) {
        throw Exception('Authentication token is missing. User might not be logged in.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/user/properties'),
        headers: _getAuthHeaders(),
      );

      print('Fetch my properties status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Successfully fetched ${data['properties']?.length ?? 0} properties');
        return data;
      } else if (response.statusCode == 401) {
        print('Unauthorized access. Token might be expired or invalid.');
        throw Exception('Unauthorized access. Please login again.');
      } else {
        print('Fetch my properties error response: ${response.body}');
        throw Exception('Failed to fetch properties: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception during fetch my properties: $e');
      throw Exception('Could not fetch properties: $e');
    }
  }

  static Future<dynamic> addProperty(Map<String, dynamic> propertyData) async {
    try {
      print('Attempting to add a new property');
      if (authToken == null) {
        throw Exception('Authentication token is missing. User might not be logged in.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/rental'),
        headers: _getAuthHeaders(),
        body: jsonEncode(propertyData),
      );

      print('Add property status code: ${response.statusCode}');
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Add property error response: ${response.body}');
        throw Exception('Failed to add property: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception during add property: $e');
      throw Exception('Failed to add property: $e');
    }
  }
}