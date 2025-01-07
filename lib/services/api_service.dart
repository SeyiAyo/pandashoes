import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../utils/debug_utils.dart';
import '../config/api_config.dart';

class ApiService {
  final http.Client _client = http.Client();

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

    final uri = Uri.parse(ApiConfig.productsEndpoint).replace(queryParameters: queryParams);
    
    DebugUtils.printApi(
      uri.toString(),
      method: 'GET',
      data: queryParams,
    );

    try {
      final response = await DebugUtils.measureAsyncOperation(
        'GET Products',
        () => _client.get(
          uri,
          headers: ApiConfig.headers,
        ).timeout(ApiConfig.connectionTimeout),
      );
      
      DebugUtils.printApi(
        uri.toString(),
        method: 'GET',
        response: response.body,
        statusCode: response.statusCode,
      );

      if (response.statusCode == 200) {
        try {
          final dynamic decodedData = json.decode(response.body);
          List<dynamic> productList;
          
          if (decodedData is Map<String, dynamic>) {
            if (decodedData.containsKey('data')) {
              productList = decodedData['data'] as List<dynamic>;
            } else if (decodedData.containsKey('results')) {
              productList = decodedData['results'] as List<dynamic>;
            } else {
              productList = [decodedData];  // Single product response
            }
          } else if (decodedData is List) {
            productList = decodedData;
          } else {
            throw FormatException('Unexpected response format: ${response.body}');
          }

          final products = productList.map((json) {
            try {
              if (json is! Map<String, dynamic>) {
                throw FormatException('Product data is not a Map: $json');
              }
              
              DebugUtils.printInfo('Parsing product: $json');
              final product = Product.fromMap(json);
              DebugUtils.printInfo('Successfully parsed product: ${product.name}');
              return product;
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
          rethrow;
        }
      } else if (response.statusCode == 0) {
        throw HttpException('CORS error: Request blocked by browser security policy. Please check CORS configuration on the server.');
      } else {
        final errorMessage = 'Failed to fetch products: ${response.statusCode}\n${response.body}';
        DebugUtils.printError(errorMessage);
        throw HttpException(errorMessage);
      }
    } on SocketException catch (e) {
      DebugUtils.printError('Network connection error', error: e);
      throw HttpException('Unable to connect to the server. Please check your internet connection.');
    } on HttpException catch (e) {
      DebugUtils.printError('HTTP error', error: e);
      rethrow;
    } on FormatException catch (e) {
      DebugUtils.printError('Data format error', error: e);
      throw HttpException('Invalid response format from server');
    } catch (e, stackTrace) {
      DebugUtils.printError(
        'Unexpected error while fetching products',
        error: e,
        stackTrace: stackTrace,
      );
      throw HttpException('An unexpected error occurred. Please try again later.');
    }
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final uri = Uri.parse(ApiConfig.categoriesEndpoint);
    
    try {
      final response = await _client.get(
        uri,
        headers: ApiConfig.headers,
      ).timeout(ApiConfig.connectionTimeout);

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 0) {
        throw HttpException('CORS error: Request blocked by browser security policy');
      } else {
        throw HttpException('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (e) {
      DebugUtils.printError('Error fetching categories', error: e);
      rethrow;
    }
  }

  void dispose() {
    _client.close();
  }
}