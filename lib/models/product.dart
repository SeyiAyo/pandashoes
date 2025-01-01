class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> sizes;
  final String category;
  final String brand;
  final List<String> colors;
  final double rating;
  final int reviewCount;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.sizes,
    required this.category,
    required this.brand,
    required this.colors,
    this.rating = 0.0,
    this.reviewCount = 0,
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
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'],
      sizes: List<String>.from(map['sizes']),
      category: map['category'],
      brand: map['brand'],
      colors: List<String>.from(map['colors']),
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] as int? ?? 0,
    );
  }
}

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Nike Air Max 270',
    price: 199.99,
    description: 'The Nike Air Max 270 delivers unrivaled comfort with its large Air unit and soft foam cushioning.',
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    category: 'Running',
    brand: 'Nike',
    colors: ['Black', 'White', 'Red'],
    rating: 4.5,
    reviewCount: 128,
  ),
  Product(
    id: '2',
    name: 'Adidas Ultraboost 21',
    price: 179.99,
    description: 'Experience incredible energy return with Ultraboost 21. More boost means more energy return.',
    imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5',
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    category: 'Running',
    brand: 'Adidas',
    colors: ['White', 'Black', 'Blue'],
    rating: 4.7,
    reviewCount: 245,
  ),
  Product(
    id: '3',
    name: 'Jordan 1 Retro High',
    price: 249.99,
    description: 'The Air Jordan 1 High is a true icon of sneaker culture, featuring classic styling and premium materials.',
    imageUrl: 'https://images.unsplash.com/photo-1607853202273-797f1c22a38e',
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    category: 'Basketball',
    brand: 'Nike',
    colors: ['Red', 'Black', 'White'],
    rating: 4.8,
    reviewCount: 567,
  ),
  Product(
    id: '4',
    name: 'Puma RS-X³',
    price: 129.99,
    description: 'The RS-X³ features bold design elements and exceptional cushioning for maximum comfort.',
    imageUrl: 'https://images.unsplash.com/photo-1608379743498-fa19ac8864da',
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    category: 'Lifestyle',
    brand: 'Puma',
    colors: ['White', 'Blue', 'Black'],
    rating: 4.3,
    reviewCount: 89,
  ),
  Product(
    id: '5',
    name: 'New Balance 990v5',
    price: 184.99,
    description: 'Made in the USA, the 990v5 provides the perfect blend of cushioning and stability.',
    imageUrl: 'https://images.unsplash.com/photo-1604163546180-039a1781c0d2',
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    category: 'Running',
    brand: 'New Balance',
    colors: ['Grey', 'Navy'],
    rating: 4.6,
    reviewCount: 312,
  ),
  Product(
    id: '6',
    name: 'Vans Old Skool',
    price: 69.99,
    description: 'The Old Skool is a classic skate shoe that has become a fashion staple.',
    imageUrl: 'https://images.unsplash.com/photo-1525966222134-fcfa99b8ae77',
    sizes: ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'],
    category: 'Skateboarding',
    brand: 'Vans',
    colors: ['Black', 'White'],
    rating: 4.4,
    reviewCount: 892,
  ),
];
