import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/model/models/product_model.dart';
import 'package:ipadresto/model/models/special_model.dart';
import 'package:ipadresto/shared/network/superbase_service.dart';

final productsControllerProvider = ChangeNotifierProvider((ref) {
  return ProductsController();
});

class ProductsController extends ChangeNotifier {
  SupabaseService superbaseService = SupabaseService();
  List<ProductModel> productModel = [];
  List<SpecialModel> specialsModel = [];
  List<Map<String, dynamic>> categoryModel = [];
  String selectedCategory = 'All';
  int selectedCategoryId = 0;

  setSelectedCategoryId(int id) {
    selectedCategoryId = id;
    notifyListeners();
  }

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

  Future<void> editProduct(
    Map<String, dynamic> productData, {
    BuildContext? context,
  }) async {
    isLoading = true;
    notifyListeners();

    log(productData.toString());
    try {
      await superbaseService.update(
        'products',
        productData,
        'id',
        productData['id'],
      );
      notifyListeners();
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to edit product');
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

  Future<List<dynamic>> getSubcategories(
    String categoryId, {
    BuildContext? context,
  }) async {
    try {
      final response = await superbaseService.getFiltered(
        'subcategories',
        'category_id',
        categoryId,
      );
      return response;
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to fetch subcategories');
      return [];
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
      final response = await SupabaseService.client
          .from('specials')
          .select(
            'id, title, starttime, endtime, days, specialfor, '
            'products(id, name, desc, price, status, image, subcategory, isSpecial, special_id, category, clicks_no, short_desc)',
          );

      log(response.toString());

      specialsModel =
          (response as List).map((e) => SpecialModel.fromJson(e)).toList();
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
