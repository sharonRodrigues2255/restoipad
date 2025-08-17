import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/model/models/product_model.dart';
import 'package:ipadresto/model/models/special_model.dart';
import 'package:ipadresto/shared/network/superbase_service.dart';

final fetchProvider = ChangeNotifierProvider((ref) {
  return FetchControllerController();
});

class FetchControllerController extends ChangeNotifier {
  SupabaseService superbaseService = SupabaseService();
  List<ProductModel> productModel = [];
  List<SpecialModel> specialsModel = [];
  List<Map<String, dynamic>> categoryModel = [];
  String selectedCategory = 'All';

  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  bool isLoading = false;

  loading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> getAllProducts({BuildContext? context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await superbaseService.getAll('products');
      log(response.toString());
      productModel = response.map((e) => ProductModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to fetch products');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAllCategories({BuildContext? context}) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await SupabaseService.client
          .from('categories')
          .select('id, title,hassub, subcategories(id, title)');
      categoryModel = response;
      log("/////// ${categoryModel.toString()}");
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to fetch products');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void _showErrorSnackbar(BuildContext? context, String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> getAllSpecials({BuildContext? context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await superbaseService.getAll('specials');
      log(response.toString());
      // Assuming you have a SpecialsModel
      specialsModel = response.map((e) => SpecialModel.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to fetch specials');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
