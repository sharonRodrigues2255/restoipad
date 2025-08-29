import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/controller/providers/shared_preference_fetch.dart';
import 'package:ipadresto/shared/providers/theme_providers.dart';
import 'package:ipadresto/view/product_listing.dart';

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
    final themeMode = ref.watch(themeModeProvider);

    // Check if dark mode is active
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.of(context).platformBrightness == Brightness.dark);

    final bgImage =
        isDark ? "assets/images/dark_bg.png" : "assets/images/light_bg.png";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            fetchController.fetchAndStoreAll(context: context);
          },
          icon: Icon(Icons.sync),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
              size: 32,
              color: isDark ? Colors.yellow : Colors.black,
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state =
                  isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/localfood.png"),
                  alignment: Alignment.bottomLeft, // bottom-left position
                  fit: BoxFit.contain, // keep aspect ratio
                ),
              ),
            ),
          ),
          Padding(
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
                            ],
                          ),
                        ),
                      )
                      : Center(
                        child: Column(
                          children: [
                            Container(
                              height: 120,
                              width: 250,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/splash.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              // decoration: BoxDecoration(
                              //   image: DecorationImage(
                              //     image: AssetImage('assets/images/menu_image.png'),
                              //     fit: BoxFit.cover,
                              //   ),
                              // ),
                              padding: EdgeInsets.only(
                                top: 100,
                                right: 170,
                                left: 170,
                                bottom: 100,
                              ),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: categories.length,
                                itemBuilder: (context, index) {
                                  final category = categories[index];

                                  // ✅ get first product image safely
                                  String bgImage =
                                      'assets/images/backupImage.png';
                                  if (category['products'] != null &&
                                      category['products'].isNotEmpty &&
                                      category['products'][0]['image'] !=
                                          null &&
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
                                                              product
                                                                  .category ==
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
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image:
                                              bgImage.startsWith('http')
                                                  ? NetworkImage(bgImage)
                                                  : AssetImage(bgImage)
                                                      as ImageProvider,
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
                                          category['title']
                                              .toString()
                                              .toUpperCase(),
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
                ],
              ),
            ),
          ),
        ],
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
                      if (isSpecialActive(special.toJson())) {
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
                                const SizedBox(height: 10),
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
                                        color: Colors.grey,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      "${special.startTime} - ${special.endTime}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
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
                                    color: Colors.black,
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
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
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

bool isSpecialActive(Map<String, dynamic> special) {
  final now = DateTime.now();

  // 1. Get today's weekday string (Monday, Tuesday…)
  final weekday =
      [
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      ][now.weekday - 1];

  // 2. Check if today is active
  final isTodayActive = special["days"][weekday] ?? false;
  if (!isTodayActive) return false;

  // 3. Parse start and end times into DateTime (for today)
  final startParts = (special["starttime"] as String).split(":");
  final endParts = (special["endtime"] as String).split(":");

  final startTime = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(startParts[0]),
    int.parse(startParts[1]),
    int.parse(startParts[2]),
  );

  final endTime = DateTime(
    now.year,
    now.month,
    now.day,
    int.parse(endParts[0]),
    int.parse(endParts[1]),
    int.parse(endParts[2]),
  );

  // 4. Check if now is within the range
  return now.isAfter(startTime) && now.isBefore(endTime);
}
