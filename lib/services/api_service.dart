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

  Future<List<Product>> getProducts({
    String? category,
    String? search,
    String? brand,
    double? minPrice,
    double? maxPrice,
  }) async {
    final queryParams = <String, String>{};
    if (category != null) queryParams['category'] = category;
    if (search != null) queryParams['search'] = search;
    if (brand != null) queryParams['brand'] = brand;
    if (minPrice != null) queryParams['min_price'] = minPrice.toString();
    if (maxPrice != null) queryParams['max_price'] = maxPrice.toString();

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
        try {
          final dynamic decodedData = json.decode(response.body);
          List<dynamic> productList;
          
          // Handle both array and object responses
          if (decodedData is Map<String, dynamic>) {
            // If response is an object with a results field
            productList = decodedData['results'] as List<dynamic>? ?? [];
          } else if (decodedData is List) {
            // If response is directly an array
            productList = decodedData;
          } else {
            throw FormatException('Unexpected response format');
          }

          final products = productList.map((json) {
            try {
              return Product.fromMap(json as Map<String, dynamic>);
            } catch (e, stackTrace) {
              DebugUtils.printError(
                'Error parsing product data',
                error: e,
                stackTrace: stackTrace,
              );
              DebugUtils.printInfo('Problematic product data: $json');
              rethrow;
            }
          }).toList();

          DebugUtils.printInfo('Successfully fetched ${products.length} products');
          return products;
        } catch (e, stackTrace) {
          DebugUtils.printError(
            'Error parsing response body',
            error: e,
            stackTrace: stackTrace,
          );
          DebugUtils.printInfo('Response body: ${response.body}');
          throw Exception('Failed to parse products: $e');
        }
      } else if (response.statusCode == 400) {
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['error']?['message'] ?? 'Bad request';
          DebugUtils.printError('API Error: $errorMessage');
          throw Exception(errorMessage);
        } catch (e) {
          DebugUtils.printError('Error parsing error response: ${response.body}');
          throw Exception('Invalid request: ${response.body}');
        }
      } else {
        final error = 'Failed to load products: ${response.statusCode} - ${response.body}';
        DebugUtils.printError(error);
        throw Exception(error);
      }
    } on SocketException catch (e) {
      const error = 'Failed to connect to server. Please check your internet connection.';
      DebugUtils.printError(error, error: e);
      throw Exception(error);
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
        try {
          final dynamic decodedData = json.decode(response.body);
          List<dynamic> categoryList;
          
          if (decodedData is Map<String, dynamic>) {
            categoryList = decodedData['results'] as List<dynamic>? ?? [];
          } else if (decodedData is List) {
            categoryList = decodedData;
          } else {
            throw FormatException('Unexpected response format');
          }

          final categories = List<Map<String, dynamic>>.from(categoryList);
          DebugUtils.printInfo('Successfully fetched ${categories.length} categories');
          return categories;
        } catch (e, stackTrace) {
          DebugUtils.printError(
            'Error parsing categories response',
            error: e,
            stackTrace: stackTrace,
          );
          DebugUtils.printInfo('Response body: ${response.body}');
          throw Exception('Failed to parse categories: $e');
        }
      } else if (response.statusCode == 400) {
        try {
          final errorData = json.decode(response.body);
          final errorMessage = errorData['error']?['message'] ?? 'Bad request';
          DebugUtils.printError('API Error: $errorMessage');
          throw Exception(errorMessage);
        } catch (e) {
          DebugUtils.printError('Error parsing error response: ${response.body}');
          throw Exception('Invalid request: ${response.body}');
        }
      } else {
        final error = 'Failed to load categories: ${response.statusCode} - ${response.body}';
        DebugUtils.printError(error);
        throw Exception(error);
      }
    } on SocketException catch (e) {
      const error = 'Failed to connect to server. Please check your internet connection.';
      DebugUtils.printError(error, error: e);
      throw Exception(error);
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