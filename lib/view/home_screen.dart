import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/controller/providers/shared_preference_fetch.dart';
import 'package:ipadresto/view/product_listing.dart';

// Color & Font constants
const Color kButtonColor = Color(0xFFC09A5D);
const Color kTextColor = Color(0xFF9C7147);
const Color kRedColor = Colors.red;

const double kPadding = 16.0;
const double kCategoryHeight = 120.0;

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fetchController = ref.watch(fetchProvider);

    final specials = fetchController.specialsModel;
    final categories = fetchController.categoryModel;

    return Scaffold(
      backgroundColor: Colors.grey[900],
      drawer: Drawer(
        child: Container(
          color: Colors.grey[850],
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: kButtonColor),
                child: Text(
                  'Update New Data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.sync, color: Colors.white),
                title: const Text(
                  'Sync Data',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  fetchController.syncData(context);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.grey[850],
        title: Container(
          height: 50,
          width: 90,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/splash.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: kTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 70),
              categories.isEmpty
              ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 100,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "No Categories Found",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Start by adding categories to organize your menu items.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          "Add Category",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/addcategory');
                        },
                      ),
                    ],
                  ),
                ),
              ) : Center(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];

                        // ✅ get first product image safely
                        String bgImage = 'assets/images/backupImage.png';
                        if (category['products'] != null &&
                            category['products'].isNotEmpty &&
                            category['products'][0]['image'] != null &&
                            category['products'][0]['image']
                                .toString()
                                .isNotEmpty) {
                          bgImage = category['products'][0]['image'];
                        }

                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ProductListing(
                                      isSpecial: false,
                                      products:
                                          ref
                                              .watch(fetchProvider)
                                              .productModel
                                              .where(
                                                (product) =>
                                                    product.category ==
                                                    category['title'],
                                              )
                                              .toList(),
                                      index: index,
                                      categories:
                                          ref
                                              .watch(fetchProvider)
                                              .categoryModel,
                                    ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 7,
                            ),
                            height: 100, // good height for cover effect
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image:
                                    bgImage.startsWith('http')
                                        ? NetworkImage(bgImage)
                                        : AssetImage(bgImage) as ImageProvider,
                                fit: BoxFit.cover, // cover effect
                                colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(
                                    0.4,
                                  ), // dark overlay for readability
                                  BlendMode.darken,
                                ),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                category['title'] ?? 'Category',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black54,
                                      blurRadius: 6,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(100)),
          height: 320,
          width: 320,
          child:
              specials.isEmpty
                  ? const Center(
                    child: Text(
                      'No Specials Available',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: specials.length,
                    itemBuilder: (context, index) {
                      final special = specials[index];
                      final now = TimeOfDay.now();
                      bool isAvailable = true;

                      // ✅ Time range check
                      try {
                        final startParts =
                            special.startTime
                                .toString()
                                .split(':')
                                .map(int.parse)
                                .toList();
                        final endParts =
                            special.endTime
                                .toString()
                                .split(':')
                                .map(int.parse)
                                .toList();

                        final start = TimeOfDay(
                          hour: startParts[0],
                          minute: startParts[1],
                        );
                        final end = TimeOfDay(
                          hour: endParts[0],
                          minute: endParts[1],
                        );

                        isAvailable = _isTimeInRange(now, start, end);
                      } catch (e) {
                        debugPrint("Error parsing time: $e");
                      }

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => ProductListing(
                                    categories: [],
                                    index: 0,
                                    isSpecial: true,
                                    special: {"title": special.title},
                                    products: special.products ?? [],
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // 🏷 Fancy Gradient Title
                              // Days text
                              const SizedBox(height: 10),

                              // Time Row (Fancy style)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.orangeAccent.withOpacity(
                                        0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: const Icon(
                                      Icons.access_time,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "${special.startTime} - ${special.endTime}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 6),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: CachedNetworkImage(
                                  imageUrl: special.products?.first.image ?? '',
                                  height: 100,
                                  width: 120,
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) => Container(
                                        height: 100,
                                        width: 120,
                                        color: Colors.grey[200],
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                  errorWidget:
                                      (context, url, error) => Image.asset(
                                        "assets/images/specials.png",
                                        height: 100,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                special.title ?? "Special Dish",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  foreground:
                                      Paint()
                                        ..shader = LinearGradient(
                                          colors: [
                                            Colors.deepOrange,
                                            Colors.orangeAccent,
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(0, 0, 200, 70),
                                        ),
                                  shadows: [
                                    Shadow(
                                      blurRadius: 6,
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _getAvailableDays(special.days ?? {}),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.orangeAccent,
                                  letterSpacing: 0.8,
                                ),
                              ),
                              SizedBox(height: 5),
                              // 📅 Days

                              // 📝 Short Description
                              Text(
                                special.specialFor ??
                                    "Delicious and fresh for today!",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ),
    );
  }

  // Utility to check time range
  bool _isTimeInRange(TimeOfDay now, TimeOfDay start, TimeOfDay end) {
    final nowMinutes = now.hour * 60 + now.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    if (startMinutes <= endMinutes) {
      return nowMinutes >= startMinutes && nowMinutes <= endMinutes;
    } else {
      // Time range spans midnight
      return nowMinutes >= startMinutes || nowMinutes <= endMinutes;
    }
  }
}

String _formatTimeOfDay(TimeOfDay time) {
  final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod; // 0 → 12
  final minute = time.minute.toString().padLeft(2, '0');
  final period = time.period == DayPeriod.am ? "AM" : "PM";
  return "$hour:$minute $period";
}

Map<String, dynamic> isTimeInRangeWithLabel(
  TimeOfDay now,
  TimeOfDay start,
  TimeOfDay end,
) {
  final nowMinutes = now.hour * 60 + now.minute;
  final startMinutes = start.hour * 60 + start.minute;
  final endMinutes = end.hour * 60 + end.minute;

  bool inRange;
  if (startMinutes <= endMinutes) {
    inRange = nowMinutes >= startMinutes && nowMinutes <= endMinutes;
  } else {
    // Time range spans midnight
    inRange = nowMinutes >= startMinutes || nowMinutes <= endMinutes;
  }

  return {
    "inRange": inRange,
    "rangeLabel": "${_formatTimeOfDay(start)} - ${_formatTimeOfDay(end)}",
  };
}

// ✅ Helper for days formatting
String _getAvailableDays(Map days) {
  final available =
      days.entries
          .where((e) => e.value == true)
          .map((e) => e.key.substring(0, 3))
          .toList();
  return available.isEmpty ? 'No days available' : available.join(', ');
}
