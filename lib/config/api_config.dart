import 'dart:io';

class ApiConfig {
  static const bool useLocalBackend = false;  // Using live backend
  static const String liveBaseUrl = 'https://shoestore-rkkw8bmc6-oluwaseyi-ayoolas-projects.vercel.app/api';
  
  static String get baseUrl {
    if (useLocalBackend) {
      if (Platform.isAndroid) {
        return 'http://10.0.2.2:8000/api';  // Android emulator
      } else if (Platform.isIOS) {
        return 'http://127.0.0.1:8000/api';  // iOS simulator
      } else {
        return 'http://localhost:8000/api';  // Web
      }
    } else {
      return liveBaseUrl;
    }
  }

  // API Endpoints
  static String get productsEndpoint => '$baseUrl/products/';
  static String get categoriesEndpoint => '$baseUrl/categories/';
  static String get ordersEndpoint => '$baseUrl/orders/';
  
  // Headers
  static Map<String, String> get headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Only add CORS headers for web platform
    if (!Platform.isAndroid && !Platform.isIOS) {
      headers.addAll({
        'Origin': 'http://localhost',  // Replace with your actual origin in production
        'Access-Control-Request-Method': 'GET, POST, PUT, DELETE',
        'Access-Control-Request-Headers': 'Content-Type, Accept',
      });
    }

    return headers;
  }
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
