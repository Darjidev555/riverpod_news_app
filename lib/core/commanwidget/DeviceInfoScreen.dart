import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoScreen extends StatefulWidget {
  @override
  _DeviceInfoScreenState createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen> {
  String? fcmToken;
  String? deviceModel;
  String? deviceManufacturer;
  String? deviceType;
  String? appVersionName;
  String? appVersionCode;
  String? packageName;

  @override
  void initState() {
    super.initState();
    getDeviceDetails();
    getFCMToken();
  }

  /// Fetch FCM Token
  Future<void> getFCMToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      fcmToken = token;
    });
    print(token);
  }

  /// Fetch Device & App Info
  Future<void> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String model = "Unknown";
    String manufacturer = "Unknown";
    String type = "Unknown";

    if (Theme.of(context).platform == TargetPlatform.android) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      model = androidInfo.model;
      manufacturer = androidInfo.manufacturer;
      type = "Android";
    } else if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      model = iosInfo.utsname.machine;
      manufacturer = "Apple";
      type = "iOS";
    }

    setState(() {
      deviceModel = model;
      deviceManufacturer = manufacturer;
      deviceType = type;
      appVersionName = packageInfo.version;
      appVersionCode = packageInfo.buildNumber;
      packageName = packageInfo.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Device & App Info")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            infoTile("FCM Token", fcmToken),
            infoTile("Device Model", deviceModel),
            infoTile("Device Company name", deviceManufacturer),
            infoTile("Device Type", deviceType),
            infoTile("App Version Name", appVersionName),
            infoTile("App Version Code", appVersionCode),
            infoTile("Package Name", packageName),
          ],
        ),
      ),
    );
  }

  Widget infoTile(String title, String? value) {
    return ListTile(
      title: Text(title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      subtitle: Text(
        value ?? "Fetching...",
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
