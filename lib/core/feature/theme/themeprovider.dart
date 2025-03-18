import 'package:delayed_display/delayed_display.dart';
import 'package:devwidget/core/commanwidget/commantextwidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeData> {
  ThemeNotifier() : super(AppThemes.lightTheme);

  void changeTheme(ThemeData themeData) {
    state = themeData;
  }
}

class AppThemes {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.black,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.white,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.white,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
  );

  static final ThemeData redTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.red,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.red,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
  );

  static final ThemeData yellowTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.yellow,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.yellow,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.black)),
  );

  static final ThemeData greenTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.green,
    hintColor: Colors.blueAccent,
    scaffoldBackgroundColor: Colors.green,
    textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.red)),
  );
}

class ThemeSwitcherScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Duration initialDelay = Duration(seconds: 1);
    final themeNotifier = ref.read(themeProvider.notifier);
    final currentTheme = ref.watch(themeProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.primaryColor,
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: CommonTextWidget(
          text: 'Theme Switcher',
          color: theme.hintColor,
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DelayedDisplay(
              delay: initialDelay,
              child: ElevatedButton(
                onPressed: () => themeNotifier.changeTheme(AppThemes.darkTheme),
                child: const Text('Dark Theme'),
              ),
            ),
            DelayedDisplay(
              delay: Duration(seconds: initialDelay.inSeconds + 1),
              child: ElevatedButton(
                onPressed: () =>
                    themeNotifier.changeTheme(AppThemes.lightTheme),
                child: const Text('Light Theme'),
              ),
            ),
            DelayedDisplay(
              delay: Duration(seconds: initialDelay.inSeconds + 2),
              child: ElevatedButton(
                onPressed: () => themeNotifier.changeTheme(AppThemes.redTheme),
                child: const Text('Red Theme'),
              ),
            ),
            DelayedDisplay(
              delay: Duration(seconds: initialDelay.inSeconds + 3),
              child: ElevatedButton(
                onPressed: () =>
                    themeNotifier.changeTheme(AppThemes.yellowTheme),
                child: const Text('Yellow Theme'),
              ),
            ),
            DelayedDisplay(
              slidingCurve: Curves.easeInOut,
              delay: Duration(seconds: initialDelay.inSeconds + 4),
              child: ElevatedButton(
                onPressed: () =>
                    themeNotifier.changeTheme(AppThemes.greenTheme),
                child: const Text('green Theme'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
