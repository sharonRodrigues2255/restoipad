class ProductModel {
  final int? id;
  final DateTime? createdAt;
  final String? name;
  final String? desc;
  final double? price;
  final String? status;
  final String? image;
  final int? specialId;
  final String? subcategory;
  final String? category;
  final int? clicksNo;
  final String? shortDesc;
  final bool? isSpecial;

  ProductModel({
    this.id,
    this.createdAt,
    this.name,
    this.desc,
    this.price,
    this.status,
    this.image,
    this.specialId,
    this.subcategory,
    this.category,
    this.clicksNo,
    this.shortDesc,
    this.isSpecial,
  });

  ProductModel copyWith({
    int? id,
    DateTime? createdAt,
    String? name,
    String? desc,
    double? price,
    String? subcategory,
    String? status,
    String? image,
    String? category,
    int? clicksNo,
    int? specialId,
    String? shortDesc,
    bool? isSpecial,
  }) {
    return ProductModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      name: name ?? this.name,
      desc: desc ?? this.desc,
      price: price ?? this.price,
      subcategory: subcategory ?? this.subcategory,
      status: status ?? this.status,
      image: image ?? this.image,
      category: category ?? this.category,
      specialId: specialId ?? this.specialId,
      clicksNo: clicksNo ?? this.clicksNo,
      shortDesc: shortDesc ?? this.shortDesc,
      isSpecial: isSpecial ?? this.isSpecial,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["id"] as int?,
      createdAt:
          json["created_at"] != null
              ? DateTime.tryParse(json["created_at"])
              : null,
      name: json["name"] as String?,
      desc: json["desc"] as String?,
      price:
          json["price"] != null
              ? (json["price"] as num)
                  .toDouble() // safe int -> double conversion
              : null,
      status: json["status"] as String?,
      image: json["image"] as String?,
      subcategory: json["subcategory"] as String?,
      isSpecial: json["isSpecial"] as bool?,
      specialId: json["special_id"] as int?,
      category: json["category"] as String?,
      clicksNo: json["clicks_no"] as int?,
      shortDesc: json["short_desc"] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "created_at": createdAt?.toIso8601String(),
      "name": name,
      "desc": desc,
      "price": price,
      "status": status,
      "special_id": specialId,
      "subcategory": subcategory,
      "image": image,
      "category": category,
      "clicks_no": clicksNo,
      "short_desc": shortDesc,
      "isSpecial": isSpecial,
    };
  }
}
