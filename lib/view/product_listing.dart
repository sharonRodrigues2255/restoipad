import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/model/models/product_model.dart';
import 'package:ipadresto/view/product_details.dart';

class ProductListing extends ConsumerWidget {
  final List<ProductModel> products;
  final List<Map<String, dynamic>> categories;
  final int index;
  final bool isSpecial;
  final Map<String, dynamic>? special;

  const ProductListing({
    super.key,
    required this.products,
    required this.categories,
    required this.index,
    required this.isSpecial,
    this.special,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = isSpecial ? {} : categories[index];

    final hasSub =
        !isSpecial &&
        category['hassub'] == true &&
        (category['subcategories'] != null &&
            category['subcategories'].isNotEmpty);

    return DefaultTabController(
      length: hasSub ? category['subcategories'].length : 1,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            height: 70,
            width: 130,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(height: 10),
            Container(
              height: hasSub ? 200 : 120,
              width: double.infinity,
              padding: const EdgeInsets.only(
                top: 20,
                left: 22,
                right: 16,
                bottom: 8,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category['title']?.toString().toUpperCase() ?? '',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFCE2227),
                    ),
                  ),
                  if (hasSub) ...[
                    const SizedBox(height: 12),
                    Container(
                      height: 70,
                      margin: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        isScrollable: false,
                        labelColor: Colors.black87,
                        unselectedLabelColor: Colors.black54,
                        labelStyle: const TextStyle(
                          fontSize: 24, // larger text
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2, // airy feel
                        ),
                        indicator: BoxDecoration(
                          color: Colors.black.withOpacity(
                            0.05,
                          ), // elegant opacity indicator
                          borderRadius: BorderRadius.circular(12),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        tabs: List.generate(
                          category['subcategories'].length,
                          (i) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            child: Tab(
                              child: Text(
                                category['subcategories'][i]['title']
                                    .toString()
                                    .toUpperCase(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child:
                  isSpecial
                      ? _buildProductList(context, products, ref)
                      : hasSub
                      ? TabBarView(
                        children: List.generate(
                          category['subcategories'].length,
                          (i) {
                            final sub = category['subcategories'][i]['title'];
                            final filteredProducts =
                                products
                                    .where((p) => (p.subcategory ?? '') == sub)
                                    .toList();
                            return _buildProductList(
                              context,
                              filteredProducts,
                              ref,
                            );
                          },
                        ),
                      )
                      : _buildProductList(context, products, ref),
            ),
          ],
        ),
      ),
    );
  }

  /// Build list of products with empty state handling
  Widget _buildProductList(
    BuildContext context,
    List<ProductModel> list,
    WidgetRef ref,
  ) {
    if (list.isEmpty) return _buildEmptyScreen(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final product = list[index];
        return _productTile(context, list, product, index, ref);
      },
    );
  }

  /// Empty state widget
  Widget _buildEmptyScreen(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 120, color: Colors.grey.shade400),
            const SizedBox(height: 24),
            const Text(
              "No Products Found",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Please check back later or contact the staff for today’s specials.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  /// Single product tile
  Widget _productTile(
    BuildContext context,
    List<ProductModel> currentList,
    ProductModel product,
    int index,
    WidgetRef ref,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    ProductDetails(products: currentList, initialIndex: index),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: SizedBox(
                width: 120,
                height: 120,
                child: _productImage(product.image),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      product.name.toString().toUpperCase(),
                      style: const TextStyle(
                        color: Color(0xFFCE2227),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Short desc
                    Text(
                      product.shortDesc ?? "Delicious and freshly made",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),

                    // Price chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.deepOrange.shade200),
                      ),
                      child: Text(
                        product.price != null
                            ? "₹${product.price!.toStringAsFixed(2)}"
                            : "Price Unavailable",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Category + Status row
                    Row(
                      children: [
                        if ((product.category ?? '').isNotEmpty) ...[
                          Icon(
                            Icons.category_outlined,
                            size: 16,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              product.category!,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        if ((product.status ?? '').isNotEmpty) ...[
                          Icon(
                            Icons.check_circle,
                            size: 16,
                            color:
                                (product.status == 'Available')
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            product.status!,
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  (product.status == 'Available')
                                      ? Colors.green
                                      : Colors.grey,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Product image with fallback
  Widget _productImage(String? url) {
    if (url == null || url.isEmpty) {
      return Image.asset("assets/images/backupImage.png", fit: BoxFit.cover);
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder:
          (context, _) => Container(
            color: Colors.grey.shade200,
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (context, _, __) =>
              Image.asset("assets/images/backupImage.png", fit: BoxFit.cover),
    );
  }
}
