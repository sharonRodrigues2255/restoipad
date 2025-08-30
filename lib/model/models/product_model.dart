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
  final Map<String, dynamic>? verities; // <-- Correct spelling and structure

  ProductModel({
    this.id,
    this.createdAt,
    this.name,
    this.desc,
    this.specialId,
    this.subcategory,
    this.price,
    this.status,
    this.image,
    this.category,
    this.clicksNo,
    this.shortDesc,
    this.isSpecial,
    this.verities,
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
    Map<String, dynamic>? verities,
  }) =>
      ProductModel(
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
        verities: verities ?? this.verities,
      );

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        name: json["name"],
        desc: json["desc"],
        price: json["price"]?.toDouble(),
        status: json["status"],
        image: json["image"],
        subcategory: json["subcategory"],
        isSpecial: json["isSpecial"],
        specialId: json["special_id"],
        category: json["category"],
        clicksNo: json["clicks_no"],
        shortDesc: json["short_desc"],
        verities: json["verities"] == null
            ? null
            : Map<String, dynamic>.from(json["verities"]), // <-- Map not List
      );

  Map<String, dynamic> toJson() => {
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
        "verities": verities, // <-- fixed spelling
      };
}
