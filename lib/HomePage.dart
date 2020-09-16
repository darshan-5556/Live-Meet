import 'package:livemeet/JoinPage.dart';
import 'package:livemeet/Login.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  bool _isInterstitialAdLoaded = false;
  bool _isRewardedAdLoaded = false;
  bool _isRewardedVideoComplete = false;

  Widget _currentAd = SizedBox(
    width: 0.0,
    height: 0.0,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // FacebookAudienceNetwork.init(
    //   testingId: "35e92a63-8102-46a4-b0f5-4fd269e6a13c",
    // );
    // // _loadInterstitialAd();
    // // _loadRewardedVideoAd();
    // _showBannerAd() {
    //   setState(() {
    //     _currentAd = FacebookBannerAd(
    //       bannerSize: BannerSize.STANDARD,
    //       listener: (result, value) {
    //         print("Banner Ad: $result -->  $value");
    //       },
    //     );
    //   });
    // }
  }

  // void _loadInterstitialAd() {
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     placementId: "YOUR_PLACEMENT_ID",
  //     listener: (result, value) {
  //       print("Interstitial Ad: $result --> $value");
  //       if (result == InterstitialAdResult.LOADED)
  //         _isInterstitialAdLoaded = true;

  //       /// Once an Interstitial Ad has been dismissed and becomes invalidated,
  //       /// load a fresh Ad by calling this function.
  //       if (result == InterstitialAdResult.DISMISSED &&
  //           value["invalidated"] == true) {
  //         _isInterstitialAdLoaded = false;
  //         _loadInterstitialAd();
  //       }
  //     },
  //   );
  // }

  // void _loadRewardedVideoAd() {
  //   FacebookRewardedVideoAd.loadRewardedVideoAd(
  //     placementId: "YOUR_PLACEMENT_ID",
  //     listener: (result, value) {
  //       print("Rewarded Ad: $result --> $value");
  //       if (result == RewardedVideoAdResult.LOADED) _isRewardedAdLoaded = true;
  //       if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
  //         _isRewardedVideoComplete = true;

  //       /// Once a Rewarded Ad has been closed and becomes invalidated,
  //       /// load a fresh Ad by calling this function.
  //       if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
  //           value["invalidated"] == true) {
  //         _isRewardedAdLoaded = false;
  //         _loadRewardedVideoAd();
  //       }
  //     },
  //   );
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId = currentUser.id;

    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        print("Online");
        break;
      case AppLifecycleState.inactive:
        usersRefrance.document(currentUserId).updateData({
          "isRequestToJoin": false,
        });
        print("offline");
        break;
      case AppLifecycleState.paused:
        print("waiting");
        break;
      case AppLifecycleState.detached:
        print("offline");
        usersRefrance.document(currentUserId).updateData({
          "isRequestToJoin": false,
        });
        break;
    }
  }

  showAlert() {
    Alert(
      style: AlertStyle(animationType: AnimationType.shrink),
      desc:
          "Have fun while using this app, keep in mind that, don't use violent content or any nudity display behaviours, otherwise strict action will be taken.",
      context: context,
      title: "Alert",
      content: Column(
        children: <Widget>[
          Container(
            height: 10.0,
          ),
          GestureDetector(
            onTap: () {
              gSignIn.signOut();
              Navigator.pop(context, true);
            },
            child: Container(
              height: 40.0,
              width: 230.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20.0)),
              child: Text(
                "Sign Out",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          )
        ],
      ),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Live Meet",
            style: TextStyle(color: Colors.yellow, fontSize: 24.0)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.info_outline,
              size: 30.0,
              color: Colors.red,
            ),
            onPressed: () {
              showAlert();
              //  interstatialAds.createADinterstatial();
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("Choose The Gender You Want To Talk.",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic)),
              ),
              Container(
                height: 20.0,
              ),
              GestureDetector(
                onTap: () async {
                  await usersRefrance
                      .document(currentUser.id)
                      .updateData({"Gender": "Male"});

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => JoinPage()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.orange])),
                  width: 220.0,
                  height: 110.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    color: Colors.red,
                    icon: Icon(
                      Icons.record_voice_over,
                      color: Colors.white,
                    ),
                    label: Text(
                      " Male ",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () async {
                      await usersRefrance
                          .document(currentUser.id)
                          .updateData({"Gender": "Female"});

                      //  interstatialAds.createADinterstatial();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => JoinPage()));
                    },
                  ),
                ),
              ),
              Container(
                height: 20.0,
              ),
              GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40.0),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.orange, Colors.red])),
                  width: 220.0,
                  height: 110.0,
                  alignment: Alignment.center,
                  child: RaisedButton.icon(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(35.0)),
                    color: Colors.green,
                    icon: Icon(
                      Icons.record_voice_over,
                      color: Colors.white,
                    ),
                    splashColor: Colors.red,
                    label: Text(
                      "Female",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    onPressed: () async {
                      await usersRefrance
                          .document(currentUser.id)
                          .updateData({"Gender": "Male"});
                      //interstatialAds.createADinterstatial();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => JoinPage()));
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _showInterstitialAd() {
  //   if (_isInterstitialAdLoaded == true)
  //     FacebookInterstitialAd.showInterstitialAd();
  //   else
  //     print("Interstial Ad not yet loaded!");
  // }

  // _showRewardedAd() {
  //   if (_isRewardedAdLoaded == true)
  //     FacebookRewardedVideoAd.showRewardedVideoAd();
  //   else
  //     print("Rewarded Ad not yet loaded!");
  // }
}
