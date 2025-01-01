import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/debug_utils.dart';

class ApiService {
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api'; // Android emulator
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:8000/api'; // iOS simulator
    } else {
      return 'http://localhost:8000/api'; // Web
    }
  }

  Future<List<Product>> getProducts({String? category, String? search}) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;

    final uri = Uri.parse('$baseUrl/products/').replace(queryParameters: queryParams);
    
    DebugUtils.printApi(
      uri.toString(),
      method: 'GET',
      data: queryParams,
    );

    try {
      final response = await DebugUtils.measureAsyncOperation(
        'GET Products',
        () => http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      DebugUtils.printApi(
        uri.toString(),
        method: 'GET',
        response: response.body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final products = data.map((json) => Product.fromMap(json)).toList();
        DebugUtils.printInfo('Successfully fetched ${products.length} products');
        return products;
      } else {
        final error = 'Failed to load products: ${response.statusCode} - ${response.body}';
        DebugUtils.printError(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      DebugUtils.printError(
        'Error fetching products',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final uri = Uri.parse('$baseUrl/categories/');
    
    DebugUtils.printApi(
      uri.toString(),
      method: 'GET',
    );

    try {
      final response = await DebugUtils.measureAsyncOperation(
        'GET Categories',
        () => http.get(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      
      DebugUtils.printApi(
        uri.toString(),
        method: 'GET',
        response: response.body,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final categories = List<Map<String, dynamic>>.from(data);
        DebugUtils.printInfo('Successfully fetched ${categories.length} categories');
        return categories;
      } else {
        final error = 'Failed to load categories: ${response.statusCode} - ${response.body}';
        DebugUtils.printError(error);
        throw Exception(error);
      }
    } catch (e, stackTrace) {
      DebugUtils.printError(
        'Error fetching categories',
        error: e,
        stackTrace: stackTrace,
      );
      throw Exception('Failed to load categories: $e');
    }
  }
}