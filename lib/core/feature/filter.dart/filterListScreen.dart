import 'package:devwidget/core/feature/filter.dart/view.dart';
import 'package:flutter/material.dart';

class Filterlistscreen extends StatelessWidget {
  final bool isFilterApplied;

  Filterlistscreen({required this.isFilterApplied});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Filtered List"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DaySelectionView()));
              },
              icon: Icon(
                weight: 2.2,
                size: 30.0,
                Icons.menu,
                color: isFilterApplied ? Colors.red : Colors.green,
              ))
        ],
      ),
      body: Center(
        child: Text(
          isFilterApplied ? "Filters Applied" : "No Filters Applied",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
