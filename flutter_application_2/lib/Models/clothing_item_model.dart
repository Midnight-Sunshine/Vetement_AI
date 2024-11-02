class ClothingItem {
  final String title;
  final String size;
  final String category;
  final String brand;
  final double price;
  final String imageUrl;
  final String documentId;

  ClothingItem({
    required this.title,
    required this.size,
    required this.category,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.documentId,
  });

  factory ClothingItem.fromDocument(doc) {
    return ClothingItem(
      title: doc['title'],
      size: doc['size'],
      category: doc['category'],
      brand: doc['brand'],
      price: (doc['price'] as num).toDouble(),
      imageUrl: doc['image'],
      documentId: doc.id,
    );
  }
}
