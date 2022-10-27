class Product {
  final String name;
  final String prodId;
  final int price;
  final List<dynamic> size;
  final String? color;
  final List<dynamic>? relatedProduct;
  final String? discreption_EN;
  final String? discreption_KU;
  final int? priceDiscont;
  final List<dynamic> images;
  final bool? isAvailable;
  final int? deliveryPrice;
  final int quantity;

  Product({
    required this.quantity,
    required this.name,
    required this.prodId,
    required this.price,
    required this.size,
    this.color,
    this.relatedProduct,
    this.discreption_EN,
    this.discreption_KU,
    this.priceDiscont,
    required this.images,
    this.isAvailable,
    this.deliveryPrice,
  });

  factory Product.fromJson(Map<String, dynamic> extractedData) {
    return Product(
        quantity: extractedData["quantity"],
        name: extractedData["productName"],
        prodId: extractedData["_id"],
        price: extractedData["customerPrice"],
        size: extractedData["size"],
        color: extractedData["color"],
        relatedProduct: extractedData["relatedProduct"],
        discreption_EN: extractedData["description_en"],
        images: extractedData["images"],
        isAvailable: extractedData["isAvailable"]);
  }
}
