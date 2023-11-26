import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:googlemobileadsdemo/models/homeview_model.dart';

class HomeView extends StatefulWidget {
  final HomeViewModel viewModel;

  const HomeView({super.key, required this.viewModel});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int userrewardscore = 0;

  @override
  Widget build(BuildContext context) {
    double mediaHeight = MediaQuery.of(context).size.height * 0.05;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: const Text('AdMob by mehdinathani'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: Colors
                        .blue, // You can change the color as per your preference
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.viewModel.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Account Balance: \$ $userrewardscore',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () {
                              // Handle redeem button press
                              // Add your redeem logic here
                            },
                            icon: const Icon(Icons.card_giftcard),
                            label: const Text(
                              'Redeem',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .orange, // Change button color as per your preference
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: mediaHeight,
                ),
                Text(
                  "Congratulations! You have earned a total of \$${userrewardscore}!",
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(
                  height: mediaHeight,
                ),
                ElevatedButton(
                  onPressed: () {
                    widget.viewModel.showRewardedAd().then((_) {
                      setState(() {
                        userrewardscore = widget.viewModel.rewardedScore;
                        debugPrint(
                            "User Score Reward Total ${userrewardscore.toString()}");
                      });
                    });
                  },
                  child: const Text('Click to Earn 1 Dollar'),
                ),
                SizedBox(
                  height: mediaHeight,
                ),
                ElevatedButton(
                  onPressed: () async {
                    widget.viewModel.showInterstitialAd();
                  },
                  child: const Text('Show Interstitial Ad'),
                ),
                SizedBox(
                  height: mediaHeight,
                ),
                const Text("Below is the Google Banner Ad."),
                SizedBox(
                  width: widget.viewModel.bannerAd.size.width.toDouble(),
                  height: widget.viewModel.bannerAd.size.height.toDouble(),
                  child: AdWidget(ad: widget.viewModel.bannerAd),
                ),
                SizedBox(
                  height: mediaHeight,
                ),
                const Text("Created by mehdinathani")
              ],
            ),
          ),
        ),
      ),
    );
  }
}
