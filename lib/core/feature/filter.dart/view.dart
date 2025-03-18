import 'package:devwidget/core/commanwidget/commantextwidget.dart';
import 'package:devwidget/core/commanwidget/newstile.dart';
import 'package:devwidget/core/feature/filter.dart/filterListScreen.dart';
import 'package:devwidget/core/feature/filter.dart/viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class DaySelectionView extends ConsumerStatefulWidget {
  @override
  _DaySelectionViewState createState() => _DaySelectionViewState();
}

class _DaySelectionViewState extends ConsumerState<DaySelectionView> {
  String selectedCategory = "Days"; // Track the selected category

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(daySelectionProvider);
    final notifier = ref.read(daySelectionProvider.notifier);

    final List<String> days = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];

    final List<String> years = [
      "2023",
      "2024",
      "2025",
      "2022",
      "2021",
      "2020",
      "2019",
      "2018"
    ];

    final List<String> months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    return Scaffold(
      appBar: AppBar(
        title: CommonTextWidget(text: 'Apply Filter'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Side - Selection Options
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    categoryButton("Days"),
                    SizedBox(height: 3.h),
                    categoryButton("Months"),
                    SizedBox(height: 3.h),
                    categoryButton("Years"),
                  ],
                ),

                // Right Side - List Based on Selected Category
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: IntrinsicWidth(
                      // Ensures the container takes only the required width
                      child: IntrinsicHeight(
                        child: getSelectionList(
                            state, notifier, days, months, years),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 2.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirmation"),
                          content: Text(
                              "Are you sure you want to clear the filter?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                notifier.clearSelection();
                                Navigator.pop(context); // Close the dialog
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Filterlistscreen(
                                        isFilterApplied: false),
                                  ),
                                );
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: CommonTextWidget(text: "Clear"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await notifier.saveSelections();
                    bool isFilterApplied = state.selectedDays.isNotEmpty ||
                        state.selectedMonths.isNotEmpty ||
                        state.selectedYears.isNotEmpty;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Filterlistscreen(isFilterApplied: isFilterApplied),
                      ),
                    );
                  },
                  child: CommonTextWidget(text: "Apply"),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget for selection buttons (Days, Months, Years)
  Widget categoryButton(String category) {
    bool isSelected = selectedCategory == category;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategory = category;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: CommonTextWidget(
          text: "Select $category",
          fontSize: 16.sp,
          color: isSelected ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  // Display the appropriate selection list based on the selected category
  Widget getSelectionList(var state, var notifier, List<String> days,
      List<String> months, List<String> years) {
    List<String> items = [];
    List<String> selectedItems = [];

    if (selectedCategory == "Days") {
      items = days;
      selectedItems = state.selectedDays;
    } else if (selectedCategory == "Months") {
      items = months;
      selectedItems = state.selectedMonths;
    } else if (selectedCategory == "Years") {
      items = years;
      selectedItems = state.selectedYears;
    }

    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: items.map((item) {
          return Row(
            mainAxisSize: MainAxisSize.min, // Avoid extra space
            children: [
              Checkbox(
                value: selectedItems.contains(item),
                onChanged: (bool? value) {
                  if (selectedCategory == "Days") {
                    notifier.toggleDay(item);
                  } else if (selectedCategory == "Months") {
                    notifier.toggleMonth(item);
                  } else if (selectedCategory == "Years") {
                    notifier.toggleYear(item);
                  }
                },
              ),
              // Space between checkbox and text
              CommonTextWidget(text: item),
            ],
          );
        }).toList(),
      ),
    );
  }
}
