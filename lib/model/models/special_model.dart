
import 'package:ipadresto/model/models/product_model.dart';

class SpecialModel {
  final int id;
  final DateTime createdAt;
  final String title;
  final String startTime;
  final String endTime;
  final Map<String, bool> days;
  final String specialFor;
  final List<ProductModel> products; // linked products

  SpecialModel({
    required this.id,
    required this.createdAt,
    required this.title,
    required this.startTime,
    required this.endTime,
    required this.days,
    required this.specialFor,
    this.products = const [],
  });

  factory SpecialModel.fromJson(Map<String, dynamic> json) {
    return SpecialModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at']),
      title: json['title'] ?? '',
      startTime: json['starttime'] ?? '',
      endTime: json['endtime'] ?? '',
      days: Map<String, bool>.from(json['days'] ?? {}),
      specialFor: json['specialfor'] ?? '',
      products: (json['products'] as List<dynamic>?)
              ?.map((p) => ProductModel.fromJson(p))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'title': title,
      'starttime': startTime,
      'endtime': endTime,
      'days': days,
      'specialfor': specialFor,
      'products': products.map((p) => p.toJson()).toList(),
    };
  }
}
