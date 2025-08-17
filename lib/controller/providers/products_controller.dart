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

  Future<void> deleteProduct(int productId, {BuildContext? context}) async {
    isLoading = true;
    notifyListeners();

    try {
      await superbaseService.delete('products', 'id', productId);
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to delete product');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>?> insertCategory(
    Map<String, dynamic> categoryData, {
    BuildContext? context,
  }) async {
    isLoading = true;
    notifyListeners();

    log(categoryData.toString());
    try {
      final response = await superbaseService.insert(
        'categories',
        categoryData,
      );
      return response;
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to insert category');
    } finally {
      getAllCategories(context: context);
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

  Future<void> updateCategory(
    Map<String, dynamic> categoryData, {
    BuildContext? context,
  }) async {
    isLoading = true;
    notifyListeners();

    log(categoryData.toString());
    try {
      final response = await superbaseService.update(
        'categories',
        categoryData,
        'id',
        int.parse(categoryData['id'].toString()),
      );

      getAllCategories(context: context);
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to update category');
    } finally {
      getAllCategories(context: context);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(int categoryId, {BuildContext? context}) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await superbaseService.delete(
        'categories',
        'id',
        categoryId,
      );
      log(response.toString());
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to delete category');
    } finally {
      getAllCategories(context: context);
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> insertSubcategory(
    Map<String, dynamic> subcategoryData, {
    BuildContext? context,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      await superbaseService.insert('subcategories', subcategoryData);
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to insert subcategory');
    } finally {
      getAllCategories(context: context);
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


  Future<void> updateSubcategory(
    Map<String, dynamic> subcategoryData, {
    BuildContext? context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await superbaseService.update(
        'subcategories',
        subcategoryData,
        'id',
        subcategoryData['id'],
      );
      log(response.toString());
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to update subcategory');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSubcategory(
    int subcategoryId, {
    BuildContext? context,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final response = await superbaseService.delete(
        'subcategories',
        'id',
        subcategoryId,
      );
      log(response.toString());
    } catch (e) {
      log(e.toString());
      _showErrorSnackbar(context, 'Failed to delete subcategory');
    } finally {
      getAllCategories(context: context);
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

Future<Map<String, dynamic>?> insertSpecial(
  Map<String, dynamic> specialData, {
  BuildContext? context,
}) async {
  isLoading = true;
  notifyListeners();

  log(specialData.toString());
  try {
    final response = await superbaseService.insert('specials', specialData);
    return response;
  } catch (e) {
    log(e.toString());
    _showErrorSnackbar(context, 'Failed to insert special');
  } finally {
    getAllSpecials(context: context);
    isLoading = false;
    notifyListeners();
  }
}

Future<void> updateSpecial(
  Map<String, dynamic> specialData, {
  BuildContext? context,
}) async {
  isLoading = true;
  notifyListeners();

  log(specialData.toString());
  try {
    await superbaseService.update(
      'specials',
      specialData,
      'id',
      int.parse(specialData['id'].toString()),
    );
    getAllSpecials(context: context);
  } catch (e) {
    log(e.toString());
    _showErrorSnackbar(context, 'Failed to update special');
  } finally {
    getAllSpecials(context: context);
    isLoading = false;
    notifyListeners();
  }
}

Future<void> deleteSpecial(int specialId, {BuildContext? context}) async {
  isLoading = true;
  notifyListeners();

  try {
    await superbaseService.delete('specials', 'id', specialId);
  } catch (e) {
    log(e.toString());
    _showErrorSnackbar(context, 'Failed to delete special');
  } finally {
    getAllSpecials(context: context);
    isLoading = false;
    notifyListeners();
  }
}


}
