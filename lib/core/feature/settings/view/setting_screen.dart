import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../commanwidget/commantextwidget.dart';
import '../../auth/viewmodel/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Fetching the current user's state using Riverpod
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black54,
        title: const CommonTextWidget(
          text: "Profile",
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlOLBRK-3wEFFeCojWlHou4nooggl5iI2PJQ&s",
                ),
                radius: 60,
              ),
              // Profile Picture
              const SizedBox(height: 20),
              if (authState.user != null)
                Column(
                  children: [
                    Text(
                      authState.user?.displayName ?? 'No Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      authState.user?.email ?? 'No Email',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                )
              else
                // If no user is authenticated, show stored name and email from SharedPreferences
                FutureBuilder(
                  future: _getUserDataFromPreferences(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          Text(
                            snapshot.data?['name'] ?? 'No Name',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            snapshot.data?['email'] ?? 'No Email',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const Text(
                        'No user data available',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      );
                    }
                  },
                ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text("Logout"),
                          content: const Text(
                              "Are you sure, do you want to Logout?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(authProvider.notifier).logout(context);
                                Navigator.pop(
                                    context); // Close dialog after logout
                              },
                              child: const Text('OK'),
                            ),
                          ],
                        );
                      });
                },
                child: Container(
                  height: 30,
                  width: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xffBB84E8),
                  ),
                  child: const Center(
                    child: CommonTextWidget(
                      text: "Logout",
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fetch user data from SharedPreferences
  Future<Map<String, String>> _getUserDataFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? email = prefs.getString('email');
    return {'name': name ?? 'No Name', 'email': email ?? 'No Email'};
  }
}
