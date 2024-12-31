class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final List<String> sizes;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.sizes,
  });
}

final List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Nike Air Max',
    price: 129.99,
    imageUrl: 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
    description: 'The Nike Air Max features a lightweight design with superior cushioning for maximum comfort. Perfect for both athletic performance and casual wear.',
    sizes: ['7', '8', '9', '10', '11'],
  ),
  Product(
    id: '2',
    name: 'Adidas Ultraboost',
    price: 159.99,
    imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5',
    description: 'Experience responsive cushioning with the Adidas Ultraboost. Energy-returning properties keep every step charged with light, fast energy.',
    sizes: ['7', '8', '9', '10', '11', '12'],
  ),
  Product(
    id: '3',
    name: 'Puma RS-X',
    price: 99.99,
    imageUrl: 'https://images.unsplash.com/photo-1608231387042-66d1773070a5',
    description: 'The Puma RS-X combines retro style with modern technology. Features a bulky design and superior cushioning for ultimate comfort.',
    sizes: ['6', '7', '8', '9', '10'],
  ),
  Product(
    id: '4',
    name: 'New Balance 574',
    price: 89.99,
    imageUrl: 'https://images.unsplash.com/photo-1539185441755-769473a23570',
    description: 'A classic silhouette meets modern comfort. The New Balance 574 offers premium cushioning and iconic style for everyday wear.',
    sizes: ['7', '8', '9', '10', '11'],
  ),
];
