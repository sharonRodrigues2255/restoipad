import 'dart:developer';
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
            SizedBox(
              height: 180,
              child:
                  specials.isEmpty
                      ? Center(
                        child: Text(
                          'No Specials Available',
                          style: TextStyle(color: kTextColor),
                        ),
                      )
                      : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: specials.length,
                        itemBuilder: (context, index) {
                          final special = specials[index];
                          final now = TimeOfDay.now();
                          bool isAvailable = true;

                          // Check if current time is in special time range
                          try {
                            final startParts =
                                special.startTime!
                                    .split(':')
                                    .map(int.parse)
                                    .toList();
                            final endParts =
                                special.endTime!
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
                            log('Error parsing special time: $e');
                          }

                          return Opacity(
                            opacity: isAvailable ? 1.0 : 0.4,
                            child: Card(
                              color: kButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              margin: const EdgeInsets.only(right: 12),
                              child: Container(
                                width: 220,
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      special.title ?? '',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${special.startTime} - ${special.endTime}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: Text(
                                        special.specialFor ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Open Specials Adding Page
        },
        backgroundColor: kButtonColor,
        icon: const Icon(Icons.local_offer),
        label: const Text('Add Special', style: TextStyle(color: Colors.white)),
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
