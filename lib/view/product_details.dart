import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:ipadresto/model/models/product_model.dart';

class ProductDetails extends StatefulWidget {
  final List<ProductModel> products;
  final int initialIndex;

  const ProductDetails({
    super.key,
    required this.products,
    required this.initialIndex,
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
        title: Container(
          height: 70,
          width: 130,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
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
              product.name.toString().toUpperCase() ?? "Product",
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
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),

                /// Long Description / Placeholder
                Text(
                  product.desc ??
                      "This dish is made with the finest ingredients to give you the perfect dining experience. Enjoy the rich taste and aroma!",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey.shade700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
