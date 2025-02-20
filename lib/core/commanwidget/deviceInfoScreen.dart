import 'package:devwidget/core/commanwidget/commantextwidget.dart';
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
      appBar: AppBar(
          backgroundColor: Colors.black54,
          title: const CommonTextWidget(
            text: "Device & App Info",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Table(
          border: TableBorder.all(color: Colors.black, width: 2.0),
          columnWidths: {
            0: FixedColumnWidth(170.0),
            //  1: FlexColumnWidth(),
          },
          children: [
            tableRow("FCM Token", fcmToken),
            tableRow("Device Model", deviceModel),
            tableRow("Device Company Name", deviceManufacturer),
            tableRow("Device Type", deviceType),
            tableRow("App Version Name", appVersionName),
            tableRow("App Version Code", appVersionCode),
            tableRow("Package Name", packageName),
          ],
        ),
      ),
    );
  }

  /// Common table row
  TableRow tableRow(String title, String? value) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[200]),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommonTextWidget(
              text: title, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CommonTextWidget(text: value ?? "Fetching...", fontSize: 12),
        ),
      ],
    );
  }
}
