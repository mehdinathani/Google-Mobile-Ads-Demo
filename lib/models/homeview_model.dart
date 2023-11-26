import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeViewModel {
  late BannerAd bannerAd;
  late InterstitialAd interstitialAd;
  late RewardedAd rewardedAd;
  bool isInterstitialAdLoaded = false;
  String interstitialAdUnitIDTest = "ca-app-pub-3940256099942544/1033173712";
  String interstitialAdUnitID = "ca-app-pub-8910362268366697/3452167028";
  int rewardedScore = 0;
  String rewardedAdUnitID = "ca-app-pub-8910362268366697/4966814274";
  String rewardedAdUnitIDTest = "ca-app-pub-3940256099942544/5224354917";
  bool isRewardedAdLoaded = false;

  HomeViewModel() {
    _loadBannerAd();
    _loadInterstitialAd();
    _loadRewardedAd();
  }
  String username = generateRandomGuestNumber();
  void _loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: const BannerAdListener(),
    )..load();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdUnitIDTest,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(onAdLoaded: (ad) {
          interstitialAd = ad;
          isInterstitialAdLoaded = true;
          // setstate
          interstitialAd.fullScreenContentCallback =
              FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
            ad.dispose();
            isInterstitialAdLoaded = false;
            debugPrint("Ad is Dismissed");
          }, onAdFailedToShowFullScreenContent: (ad, error) {
            ad.dispose();
            isInterstitialAdLoaded = false;
            debugPrint("Ad is Dismissed");
          });
        }, onAdFailedToLoad: ((error) {
          interstitialAd.dispose();
        })));
  }

  void _loadRewardedAd() {
    RewardedAd.load(
        adUnitId: rewardedAdUnitIDTest,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
          rewardedAd = ad;
          isRewardedAdLoaded = true;
        }, onAdFailedToLoad: (error) {
          rewardedAd.dispose();
        }));
  }

  void showInterstitialAd() {
    if (isInterstitialAdLoaded) {
      interstitialAd.show().then((_) {
        // After the ad is shown, reload a new interstitial ad for the next time
        _loadInterstitialAd();
      }).catchError((error) {
        debugPrint('Failed to show interstitial ad: $error');
        // If the ad fails to show, reload a new interstitial ad for the next time
        _loadInterstitialAd();
      });
    } else {
      debugPrint('Interstitial Ad not loaded. Attempting to load...');
      _loadInterstitialAd();
    }
  }

  void callBackshowInterstitialAd() {
    if (!isInterstitialAdLoaded) {
      _loadInterstitialAd();
      showInterstitialAd();
    }
  }

  Future<void> showRewardedAd() async {
    if (isRewardedAdLoaded) {
      Completer<void> adCompleter = Completer<void>();

      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _loadRewardedAd();
          adCompleter.complete();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _loadRewardedAd();
          adCompleter.completeError("Failed to show rewarded ad: $error");
        },
      );

      rewardedAd.show(onUserEarnedReward: (ad, reward) {
        rewardedScore++;
        debugPrint("Total rewarded Score $rewardedScore ");
        adCompleter.complete();
      });

      isRewardedAdLoaded = false;
      return adCompleter.future;
    }
  }

  static String generateRandomGuestNumber() {
    // Generate a random number between 1000 and 9999 for 'Guest'
    Random random = Random();
    return 'Guest${1000 + random.nextInt(9000)}';
  }
}
