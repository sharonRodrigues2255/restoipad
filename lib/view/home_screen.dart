import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ipadresto/controller/providers/shared_preference_fetch.dart';

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
                  'Menu',
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
        title: const Text('Home', style: TextStyle(color: kTextColor)),
        iconTheme: const IconThemeData(color: kTextColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),

            // Categories Grid
            Expanded(
              child:
                  categories.isEmpty
                      ? Center(
                        child: Text(
                          'No Categories Available',
                          style: TextStyle(color: kTextColor),
                        ),
                      )
                      : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return Card(
                            color: kButtonColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Text(
                                category['title'] ?? 'Category',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
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
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: SizedBox(
          height: 220,
          child:
              specials.isEmpty
                  ? Center(
                    child: Text(
                      'No Specials Available',
                      style: TextStyle(
                        color: kTextColor,
                        fontSize: 16,
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

                      // ✅ Parse timings safely
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

                      // ✅ Get background image (first product > next product > backup asset)
                      String bgImage = 'assets/images/backupImage.png';

                      if (special.products != null &&
                          special.products!.isNotEmpty) {
                        // First product image
                        final firstImage = special.products![0].image;
                        if (firstImage != null && firstImage.isNotEmpty) {
                          bgImage = firstImage;
                        }
                        // Second product image fallback
                        else if (special.products!.length > 1) {
                          final secondImage = special.products![1].image;
                          if (secondImage != null && secondImage.isNotEmpty) {
                            bgImage = secondImage;
                          }
                        }
                      }

                      return Opacity(
                        opacity: isAvailable ? 1.0 : 0.5,
                        child: Container(
                          width: 260,
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(2, 4),
                              ),
                            ],
                            image: DecorationImage(
                              image:
                                  bgImage.startsWith('http')
                                      ? NetworkImage(bgImage)
                                      : AssetImage(bgImage) as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.7),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                Text(
                                  special.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Spacer(),

                                // Time
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.access_time,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${special.startTime} - ${special.endTime}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                Text(
                                  _getAvailableDays(special.days ?? {}),
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  special.specialFor ?? '',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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

// ✅ Helper for days formatting
String _getAvailableDays(Map days) {
  final available =
      days.entries
          .where((e) => e.value == true)
          .map((e) => e.key.substring(0, 3))
          .toList();
  return available.isEmpty ? 'No days available' : available.join(', ');
}
