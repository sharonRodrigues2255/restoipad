import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipadresto/model/models/product_model.dart';
import 'package:ipadresto/model/models/special_model.dart'; // Assuming you have this

class ProductDetails extends StatefulWidget {
  final List<ProductModel> products;
  final int initialIndex;
  final SpecialModel specials; // 👈 pass specials here

  const ProductDetails({
    super.key,
    required this.products,
    required this.initialIndex,
    required this.specials,
  });

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final products = widget.products;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80, // 👈 just a little taller than default (56)
        title: Padding(
          padding: const EdgeInsets.only(top: 8), // small top spacing
          child: Image.asset(
            "assets/images/logogreydark.png",
            height: 60, // preferred logo height
            fit: BoxFit.contain,
          ),
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: products.length,
        onPageChanged: (index) {
          setState(() => _currentIndex = index);
        },
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductDetails(product);
        },
      ),
    );
  }

  Widget _buildProductDetails(ProductModel product) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 25),
          Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: 300,
            width: double.infinity,
            child:
                product.image != null && product.image!.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: product.image!,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Image.asset(
                            "assets/images/backupImage.png",
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                    )
                    : Image.asset(
                      "assets/images/backupImage.png",
                      fit: BoxFit.cover,
                    ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 10, bottom: 0),
            child: Text(
              product.name.toString().toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 35,
                color: Color(0xFFCE2227),
              ),
            ),
          ),

          /// Details Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Price
                Text(
                  product.price != null
                      ? "₹${product.price!.toStringAsFixed(2)}"
                      : "Price Unavailable",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                const SizedBox(height: 12),

                /// Short Description
                Text(
                  product.shortDesc ?? "Delicious and freshly prepared!",
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          if (product.verities != null && product.verities!.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Wrap(
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
                          border: Border.all(color: Colors.white70, width: 1.5),
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
            ),
          ],
          const SizedBox(height: 30),
          Divider(color: Colors.white),

          /// Specials Section 👇
          if (widget.specials.products!.isNotEmpty &&
              widget.products[widget.initialIndex].isSpecial != true) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Text(
                  "Check out the ${widget.specials.title}!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 180,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.specials.products?.length ?? 0,
                  itemBuilder: (context, index) {
                    final special = widget.specials.products?[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ProductDetails(
                                  products: widget.specials.products ?? [],
                                  initialIndex: index,
                                  specials: widget.specials,
                                ),
                          ),
                        );
                      },
                      child: Container(
                        width: 160,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Special Image
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child:
                                  special != null && special!.image != null
                                      ? CachedNetworkImage(
                                        imageUrl: special.image!,
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      )
                                      : Image.asset(
                                        "assets/images/backupImage.png",
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                            ),

                            /// Title
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                special?.name ?? "Special",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),

                            /// Time & Days
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ],
      ),
    );
  }
}
