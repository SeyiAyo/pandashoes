import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import '../models/order.dart';
import '../models/cart.dart';
import 'package:uuid/uuid.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _uuid = const Uuid();

  Future<Order> createOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
    required String shippingAddress,
  }) async {
    final orderRef = _firestore.collection('orders').doc();
    
    final order = Order(
      id: _uuid.v4(),
      userId: userId,
      items: items,
      total: total,
      shippingAddress: shippingAddress,
      createdAt: DateTime.now(),
    );

    await orderRef.set(order.toMap());
    return order;
  }

  Future<List<Order>> getUserOrders(String userId) async {
    final snapshot = await _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => Order.fromMap(doc.data())).toList();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': status,
    });
  }
}
