import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/controller/providers/shared_preference_fetch.dart';
import 'package:ipadresto/view/product_listing.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

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
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            fetchController.fetchAndStoreAll(context: context);
          },
          icon: Icon(Icons.sync),
        ),
        actions: [
          // IconButton(
          //   icon: Icon(
          //     isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
          //     size: 32,
          //     color: isDark ? Colors.yellow : Colors.black,
          //   ),
          //   onPressed: () {
          //     ref.read(themeModeProvider.notifier).state =
          //         isDark ? ThemeMode.light : ThemeMode.dark;
          //   },
          // ),
        ],
      ),
      body: Stack(
        children: [
          // Container(
          //   width: double.infinity,
          //   height: double.infinity,
          //   decoration: BoxDecoration(
          //     image: DecorationImage(
          //       fit: BoxFit.cover,
          //       image: AssetImage("assets/images/BACKGROUD.png"),
          //     ),
          //   ),
          // ),
          Align(
            alignment: Alignment.bottomRight,
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
                              constraints: BoxConstraints(
                                maxWidth: 500,
                                maxHeight: 120,
                              ),
                              height: 120,
                              width: 500,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/images/logogreydark.png',
                                  ),
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                top: 100,
                                right: 120,
                                left: 120,
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
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: const Border(
                                          top: BorderSide(
                                            color:
                                                Colors
                                                    .grey, // 🟠 border only on top
                                            width: 3,
                                          ),
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 8,
                                            offset: const Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        child: Center(
                                          child: Text(
                                            category['title']
                                                .toString()
                                                .toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
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

          Positioned(
            right: 20,
            bottom: 40,
            child:
                specials.isEmpty
                    ? const SizedBox()
                    : Column(
                      children:
                          specials.map((special) {
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
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 20),
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF1C1C1C),
                                        Color(0xFF0A0A0A),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      width: 4,
                                      color: Colors.white,
                                    ),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          special.title ?? "Special",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orangeAccent,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          "${special.startTime} - ${special.endTime}",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          _getAvailableDays(special.days ?? {}),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.white54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox();
                          }).toList(),
                    ),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: ElevatedButton(
              onPressed: _launchPrivacyPolicy,
              child: Text('Privacy Policy'),
            ),
          ),
        ],
      ),
    );
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

final Uri _privacyPolicyUrl = Uri.parse(
  'https://curryislandindiankitchen.com/privacy-policy/',
);

Future<void> _launchPrivacyPolicy() async {
  if (!await launchUrl(
    _privacyPolicyUrl,
    mode: LaunchMode.externalApplication,
  )) {
    throw 'Could not launch $_privacyPolicyUrl';
  }
}
