import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool isLoading = false;

  void setSelectedCategory(String category) {
    selectedCategory = category;
    notifyListeners();
  }

  loading() {
    isLoading = true;
    notifyListeners();
  }

  stopLoading() {
    isLoading = false;
    notifyListeners();
  }

  void _showErrorSnackbar(BuildContext? context, String message) {
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  // 1️⃣ FETCH DATA FROM SUPABASE AND STORE IN SHARED PREFERENCES
  Future<void> fetchAndStoreAll({BuildContext? context}) async {
    loading();
    try {
      // Fetch Products
      final productsResp = await superbaseService.getAll('products');

      // Fetch Categories
      final categoriesResp = await SupabaseService.client
          .from('categories')
          .select('id, title,hassub, subcategories(id, title)');
      final specialsResp = await superbaseService.getAll('specials');
      log(
        'Fetch and store complete $productsResp special $specialsResp categories $categoriesResp',
      );
      categoryModel = List<Map<String, dynamic>>.from(categoriesResp);

      final specialsList =
          specialsResp.map((e) => SpecialModel.fromJson(e)).toList();
      final productsList =
          productsResp.map((e) => ProductModel.fromJson(e)).toList();
      productModel = productsList;
      specialsModel = specialsList;

      notifyListeners();

      // Store in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'products',
        jsonEncode(productsList.map((p) => p.toJson()).toList()),
      );
      await prefs.setString('categories', jsonEncode(categoryModel));
      await prefs.setString(
        'specials',
        jsonEncode(specialsList.map((s) => s.toJson()).toList()),
      );

      ScaffoldMessenger.of(
        context!,
      ).showSnackBar(const SnackBar(content: Text('Data synced successfully')));
    } catch (e) {
      log('Fetch and store error: $e');
      _showErrorSnackbar(context, 'Failed to fetch data');
    } finally {
      loadFromSharedPrefs();
      stopLoading();
    }
  }

  // 2️⃣ LOAD FROM SHARED PREFERENCES INTO VARIABLES
  Future<void> loadFromSharedPrefs({BuildContext? context}) async {
    loading();
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load products
      final productsJson = prefs.getString('products');
      if (productsJson != null) {
        final decoded = jsonDecode(productsJson) as List<dynamic>;
        productModel = decoded.map((p) => ProductModel.fromJson(p)).toList();
      }

      // Load categories
      final categoriesJson = prefs.getString('categories');
      if (categoriesJson != null) {
        final decoded = jsonDecode(categoriesJson) as List<dynamic>;
        categoryModel = List<Map<String, dynamic>>.from(decoded);
      }

      // Load specials
      final specialsJson = prefs.getString('specials');
      if (specialsJson != null) {
        final decoded = jsonDecode(specialsJson) as List<dynamic>;
        specialsModel = decoded.map((s) => SpecialModel.fromJson(s)).toList();
      }

      notifyListeners();
      ScaffoldMessenger.of(
        context!,
      ).showSnackBar(const SnackBar(content: Text('Data loaded from cache')));
    } catch (e) {
      log('Load from prefs error: $e');
      _showErrorSnackbar(context, 'Failed to load cached data');
    } finally {
      stopLoading();
    }
  }

  // 3️⃣ SYNC BUTTON FUNCTION
  void syncData(BuildContext context) {
    fetchAndStoreAll(context: context);
  }
}
