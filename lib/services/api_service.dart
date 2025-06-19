import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://fakestoreapi.com';
  static const Duration timeoutDuration = Duration(seconds: 10);

  static Future<List<Product>> fetchProducts() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/products'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(timeoutDuration);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        throw HttpException(
          'Failed to load products. Status code: ${response.statusCode}',
        );
      }
    } on SocketException {
      throw const SocketException(
        'No internet connection. Please check your network and try again.',
      );
    } on HttpException {
      rethrow;
    } on FormatException {
      throw const FormatException('Invalid response format from server.');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }
  }
}
