import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final Product product;
  final String size;
  int quantity;

  CartItem({
    required this.product,
    required this.size,
    this.quantity = 1,
  });
}

class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  double get total => _items.fold(
        0,
        (sum, item) => sum + (item.product.price * item.quantity),
      );

  void addItem(Product product, String size) {
    final existingItem = _items.firstWhere(
      (item) => item.product.id == product.id && item.size == size,
      orElse: () => CartItem(product: product, size: size, quantity: 0),
    );

    if (existingItem.quantity == 0) {
      _items.add(CartItem(product: product, size: size));
    } else {
      existingItem.quantity++;
    }
    notifyListeners();
  }

  void removeItem(Product product, String size) {
    _items.removeWhere(
      (item) => item.product.id == product.id && item.size == size,
    );
    notifyListeners();
  }

  void updateQuantity(Product product, String size, int quantity) {
    final item = _items.firstWhere(
      (item) => item.product.id == product.id && item.size == size,
    );
    item.quantity = quantity;
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
