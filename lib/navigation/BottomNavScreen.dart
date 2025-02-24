import 'package:devwidget/core/feature/artical/view/artical_screen.dart';
import 'package:devwidget/core/feature/theme/themeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/feature/settings/view/setting_screen.dart';
import '../core/feature/home/view/home_screen.dart';

final bottomNavIndexProvider = StateProvider<int>((ref) => 0);

class BottomNavScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(bottomNavIndexProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.black87,
          currentIndex: currentIndex,
          onTap: (index) {
            ref.read(bottomNavIndexProvider.notifier).state = index;
          },
          selectedItemColor: theme.hintColor,
          // Matching Newstile color
          unselectedItemColor: Colors.white,
          // White for contrast
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
      body: _getBody(currentIndex),
    );
  }

  // Function to switch between screens
  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return ArticalScreen();
      case 2:
        return ThemeSwitcherScreen();
      default:
        return Center(
            child:
                Text('Unknown Screen', style: TextStyle(color: Colors.white)));
    }
  }
}
