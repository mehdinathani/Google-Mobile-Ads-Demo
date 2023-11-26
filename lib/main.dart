import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:googlemobileadsdemo/models/homeview_model.dart';
import 'package:googlemobileadsdemo/screens/home_view.dart';

void main() {
  var devices = ["4457C64AB8CD89185416D454C4A4A4"];
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration requestConfiguration =
      RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Google AdMob Demo",
      home: HomeView(
        viewModel: HomeViewModel(),
      ),
    );
  }
}
