import 'cart.dart';
import 'product.dart';

class Order {
  final String id;
  final String userId;
  final List<CartItem> items;
  final double total;
  final String shippingAddress;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.shippingAddress,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'shippingAddress': shippingAddress,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'] as String,
      userId: map['userId'] as String,
      items: (map['items'] as List<dynamic>).map((item) {
        final itemMap = item as Map<String, dynamic>;
        return CartItem(
          id: itemMap['id'] as String,
          product: Product.fromMap(itemMap['product'] as Map<String, dynamic>),
          color: itemMap['color'] as String,
          quantity: itemMap['quantity'] as int,
        );
      }).toList(),
      total: map['total'] as double,
      shippingAddress: map['shippingAddress'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
