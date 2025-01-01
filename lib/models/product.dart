import 'dart:convert';

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> sizes;
  final String category;
  final String brand;
  final List<String> colors;
  final double rating;
  final int reviewCount;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.sizes,
    required this.category,
    required this.brand,
    required this.colors,
    required this.rating,
    required this.reviewCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'category': category,
      'brand': brand,
      'colors': colors,
      'rating': rating,
      'reviewCount': reviewCount,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id']?.toString() ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] is num) ? (map['price'] as num).toDouble() : 0.0,
      imageUrl: map['imageUrl'] ?? map['image'] ?? '',
      sizes: List<String>.from(map['sizes'] ?? []),
      category: map['category'] ?? '',
      brand: map['brand'] ?? '',
      colors: List<String>.from(map['colors'] ?? []),
      rating: (map['rating'] is num) ? (map['rating'] as num).toDouble() : 0.0,
      reviewCount: map['reviewCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) => Product.fromMap(json.decode(source));

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? sizes,
    String? category,
    String? brand,
    List<String>? colors,
    double? rating,
    int? reviewCount,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      sizes: sizes ?? this.sizes,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      colors: colors ?? this.colors,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
    );
  }
}

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Nike Air Max 270',
    description: 'The Nike Air Max 270 delivers unrivaled comfort with its large Air unit and soft foam cushioning.',
    price: 199.99,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    sizes: ['7', '8', '9'],
    category: 'Running',
    brand: 'Nike',
    colors: ['Black', 'White', 'Red'],
    rating: 4.5,
    reviewCount: 128,
  ),
  Product(
    id: '2',
    name: 'Adidas Ultraboost 21',
    description: 'Experience incredible energy return with Ultraboost 21. More boost means more energy return.',
    price: 179.99,
    imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5',
    sizes: ['7', '8', '9'],
    category: 'Running',
    brand: 'Adidas',
    colors: ['White', 'Black', 'Blue'],
    rating: 4.7,
    reviewCount: 245,
  ),
  Product(
    id: '3',
    name: 'Jordan 1 Retro High',
    description: 'The Air Jordan 1 High is a true icon of sneaker culture, featuring classic styling and premium materials.',
    price: 249.99,
    imageUrl: 'https://images.unsplash.com/photo-1607853202273-797f1c22a38e',
    sizes: ['7', '8', '9'],
    category: 'Basketball',
    brand: 'Nike',
    colors: ['Red', 'Black', 'White'],
    rating: 4.8,
    reviewCount: 567,
  ),
  Product(
    id: '4',
    name: 'Puma RS-X³',
    description: 'The RS-X³ features bold design elements and exceptional cushioning for maximum comfort.',
    price: 129.99,
    imageUrl: 'https://images.unsplash.com/photo-1608379743498-fa19ac8864da',
    sizes: ['7', '8', '9'],
    category: 'Lifestyle',
    brand: 'Puma',
    colors: ['White', 'Blue', 'Black'],
    rating: 4.3,
    reviewCount: 89,
  ),
  Product(
    id: '5',
    name: 'New Balance 990v5',
    description: 'Made in the USA, the 990v5 provides the perfect blend of cushioning and stability.',
    price: 184.99,
    imageUrl: 'https://images.unsplash.com/photo-1604163546180-039a1781c0d2',
    sizes: ['7', '8', '9'],
    category: 'Running',
    brand: 'New Balance',
    colors: ['Grey', 'Navy'],
    rating: 4.6,
    reviewCount: 312,
  ),
  Product(
    id: '6',
    name: 'Vans Old Skool',
    description: 'The Old Skool is a classic skate shoe that has become a fashion staple.',
    price: 69.99,
    imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77',
    sizes: ['7', '8', '9'],
    category: 'Skateboarding',
    brand: 'Vans',
    colors: ['Black', 'White'],
    rating: 4.4,
    reviewCount: 892,
  ),
];
