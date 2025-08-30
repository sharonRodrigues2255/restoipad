import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/model/models/product_model.dart';
import 'package:ipadresto/view/product_details.dart';

class ProductListing extends ConsumerStatefulWidget {
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
  ConsumerState<ProductListing> createState() => _ProductListingState();
}

class _ProductListingState extends ConsumerState<ProductListing>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    final category = widget.isSpecial ? {} : widget.categories[widget.index];
    final hasSub =
        !widget.isSpecial &&
        category['hassub'] == true &&
        (category['subcategories'] != null &&
            category['subcategories'].isNotEmpty);

    _tabController = TabController(
      length: hasSub ? category['subcategories'].length : 1,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.isSpecial ? {} : widget.categories[widget.index];

    final hasSub =
        !widget.isSpecial &&
        category['hassub'] == true &&
        (category['subcategories'] != null &&
            category['subcategories'].isNotEmpty);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: SizedBox(
          height: 60,
          child: Image.asset("assets/images/logogreydark.png"),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Text(
                  category['title']?.toString().toUpperCase() ?? '',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFCE2227),
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),

          // Subcategory Tabs
          if (hasSub)
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(.8),
                borderRadius: BorderRadius.circular(20),
                border: const Border(
                  top: BorderSide(color: Colors.white, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false, // 🔥 spread evenly
                indicator: BoxDecoration(
                  color: Colors.white.withOpacity(.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade400,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                tabs: List.generate(
                  category['subcategories'].length,
                  (i) => Tab(
                    text:
                        category['subcategories'][i]['title']
                            .toString()
                            .toUpperCase(),
                  ),
                ),
              ),
            ),

          // Product list
          Expanded(
            child:
                widget.isSpecial
                    ? _buildProductList(widget.products)
                    : hasSub
                    ? TabBarView(
                      controller: _tabController,
                      children: List.generate(
                        category['subcategories'].length,
                        (i) {
                          final sub = category['subcategories'][i]['title'];
                          final filtered =
                              widget.products
                                  .where((p) => (p.subcategory ?? '') == sub)
                                  .toList();
                          return _buildProductList(
                            filtered,
                            heading: sub.toString(),
                          );
                        },
                      ),
                    )
                    : _buildProductList(widget.products),
          ),
        ],
      ),
    );
  }

  /// Builds list with optional heading
  Widget _buildProductList(List<ProductModel> list, {String? heading}) {
    if (list.isEmpty) return _buildEmptyScreen();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (heading != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    heading.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(child: Container(height: 2, color: Colors.white)),
              ],
            ),
          ),
        ...list.asMap().entries.map((entry) {
          final index = entry.key;
          final product = entry.value;
          return _productTile(product, list, index);
        }),
      ],
    );
  }

  /// Empty state
  Widget _buildEmptyScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fastfood, size: 100, color: Colors.grey.shade700),
          const SizedBox(height: 20),
          const Text(
            "No Products Found",
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            "Check back later for updates",
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  /// Product card with varieties
  Widget _productTile(
    ProductModel product,
    List<ProductModel> currentList,
    int index,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) =>
                    ProductDetails(products: currentList, initialIndex: index),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade800),
        ),
        child: Row(
          children: [
            // Image
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

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    Text(
                      product.name.toString().toUpperCase(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),

                    // Description
                    Text(
                      product.shortDesc ?? "",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 8),

                    // Varieties (🔥 visible + improved style)
                    if (product.verities != null &&
                        product.verities!.isNotEmpty) ...[
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children:
                            product.verities!.entries.map((entry) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white70,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  "${entry.key}: \$${entry.value}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const SizedBox(height: 10),
                    ],

                    // Price & Status
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            product.price != null
                                ? "\$${product.price!.toStringAsFixed(2)}"
                                : "Price N/A",
                            style: const TextStyle(
                              color: Colors.deepOrange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.circle,
                          size: 12,
                          color:
                              product.status == "Available"
                                  ? Colors.green
                                  : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.status ?? "",
                          style: TextStyle(
                            color:
                                product.status == "Available"
                                    ? Colors.green
                                    : Colors.grey,
                            fontSize: 12,
                          ),
                        ),
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

  /// Product image (fixed top crop)
  Widget _productImage(String? url) {
    if (url == null || url.isEmpty) {
      return Image.asset(
        "assets/images/backupImage.png",
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      );
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      placeholder:
          (context, _) => Container(
            color: Colors.grey.shade800,
            child: const Center(child: CircularProgressIndicator()),
          ),
      errorWidget:
          (_, __, ___) => Image.asset(
            "assets/images/backupImage.png",
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
    );
  }
}
