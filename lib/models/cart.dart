import 'package:flutter/foundation.dart';
import 'product.dart';

class CartItem {
  final String id;
  final Product product;
  final String color;
  final int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.color,
    required this.quantity,
  });

  double get totalPrice => product.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'color': color,
      'quantity': quantity,
    };
  }
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => {..._items};

  int get itemCount => _items.length;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.totalPrice;
    });
    return total;
  }

  void addItem(Product product, String color) {
    final itemId = '${product.id}_$color';
    
    if (_items.containsKey(itemId)) {
      _items.update(
        itemId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          product: existingCartItem.product,
          color: existingCartItem.color,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        itemId,
        () => CartItem(
          id: itemId,
          product: product,
          color: color,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void decrementItem(Product product, String color) {
    final itemId = '${product.id}_$color';
    if (_items.containsKey(itemId)) {
      if (_items[itemId]!.quantity > 1) {
        _items.update(
          itemId,
          (existingCartItem) => CartItem(
            id: existingCartItem.id,
            product: existingCartItem.product,
            color: existingCartItem.color,
            quantity: existingCartItem.quantity - 1,
          ),
        );
      } else {
        removeItem(itemId);
      }
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.remove(itemId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
