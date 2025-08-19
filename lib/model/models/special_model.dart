import 'package:ipadresto/model/models/product_model.dart';

class SpecialModel {
  final int? id;
  final DateTime? createdAt;
  final String? title;
  final String? startTime;
  final String? endTime;
  final Map<String, bool>? days;
  final String? specialFor;
  final List<ProductModel>? products; // linked products

  SpecialModel({
    this.id,
    this.createdAt,
    this.title,
    this.startTime,
    this.endTime,
    this.days,
    this.specialFor,
    this.products,
  });

  factory SpecialModel.fromJson(Map<String, dynamic> json) {
    return SpecialModel(
      id: json['id'] as int?,
      createdAt:
          json['created_at'] != null
              ? DateTime.tryParse(json['created_at'].toString())
              : null,
      title: json['title'] as String?,
      startTime: json['starttime']?.toString(),
      endTime: json['endtime']?.toString(),
      days:
          (json['days'] != null)
              ? Map<String, bool>.from(json['days'] as Map)
              : null,
      specialFor: json['specialfor'] as String?,
      products:
          (json['products'] as List<dynamic>?)
              ?.map((p) => ProductModel.fromJson(p))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'title': title,
      'starttime': startTime,
      'endtime': endTime,
      'days': days,
      'specialfor': specialFor,
      'products': products?.map((p) => p.toJson()).toList(),
    };
  }
}
