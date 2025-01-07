import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/debug_utils.dart';

class ApiService {
  static String get baseUrl {
    const liveUrl = 'https://shoestore-rkkw8bmc6-oluwaseyi-ayoolas-projects.vercel.app/api';
    const useLocalBackend = false;  // Set to false to use live backend

    if (useLocalBackend) {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api';  // Android emulator
      } else if (Platform.isIOS) {
        return 'http://127.0.0.1:8000/api';  // iOS simulator
      } else {
        return 'http://localhost:8000/api';  // Web
      }
    } else {
      return liveUrl;
    }
  }

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

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
        () => http.get(uri, headers: _headers),
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
          
          // Handle DRF's paginated response format
          if (decodedData is Map<String, dynamic>) {
            if (decodedData.containsKey('results')) {
              // Paginated response
              productList = decodedData['results'] as List<dynamic>;
              
              final count = decodedData['count'] as int?;
              if (count != null) {
                DebugUtils.printInfo('Total products available: $count');
              }
            } else {
              // Single object response
              productList = [decodedData];
            }
          } else if (decodedData is List) {
            // Direct list response
            productList = decodedData;
          } else {
            throw FormatException('Unexpected response format');
          }

          final products = productList.map((json) {
            if (json is! Map<String, dynamic>) {
              throw FormatException('Product data is not a Map: $json');
            }
            return Product.fromMap(json);
          }).toList();

          DebugUtils.printInfo('Successfully parsed ${products.length} products');
          return products;
        } catch (e, stackTrace) {
          DebugUtils.printError(
            'Error parsing response',
            error: e,
            stackTrace: stackTrace,
          );
          DebugUtils.printInfo('Response body: ${response.body}');
          rethrow;
        }
      } else {
        final error = 'Failed to fetch products: ${response.statusCode} - ${response.body}';
        DebugUtils.printError(error);
        throw HttpException(error);
      }
    } on SocketException catch (e) {
      const error = 'Failed to connect to server. Please check your internet connection.';
      DebugUtils.printError(error, error: e);
      throw HttpException(error);
    } catch (e, stackTrace) {
      DebugUtils.printError(
        'Error fetching products',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
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
        () => http.get(uri, headers: _headers),
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
          
          // Handle DRF's response format
          if (decodedData is Map<String, dynamic>) {
            if (decodedData.containsKey('results')) {
              categoryList = decodedData['results'] as List<dynamic>;
            } else {
              categoryList = [decodedData];
            }
          } else if (decodedData is List) {
            categoryList = decodedData;
          } else {
            throw FormatException('Unexpected response format');
          }

          final categories = categoryList.map((item) {
            if (item is! Map<String, dynamic>) {
              throw FormatException('Category data is not a Map: $item');
            }
            return item;
          }).toList();

          DebugUtils.printInfo('Successfully fetched ${categories.length} categories');
          return categories;
        } catch (e, stackTrace) {
          DebugUtils.printError(
            'Error parsing categories',
            error: e,
            stackTrace: stackTrace,
          );
          DebugUtils.printInfo('Response body: ${response.body}');
          rethrow;
        }
      } else {
        final error = 'Failed to fetch categories: ${response.statusCode} - ${response.body}';
        DebugUtils.printError(error);
        throw HttpException(error);
      }
    } on SocketException catch (e) {
      const error = 'Failed to connect to server. Please check your internet connection.';
      DebugUtils.printError(error, error: e);
      throw HttpException(error);
    } catch (e, stackTrace) {
      DebugUtils.printError(
        'Error fetching categories',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}