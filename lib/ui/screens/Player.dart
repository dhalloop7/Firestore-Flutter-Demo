import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player/youtube_player.dart';

class Player extends StatefulWidget {
  final DocumentSnapshot videoDocument;

  Player({Key key, @required this.videoDocument}) : super(key: key);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;
  VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: FirebaseAdMob.testAppId, analyticsEnabled: true);
    _bannerAd = createBannerAd()..load();
    _bannerAd.show();
    _interstitialAd = createInterstitialAd()..load();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
        if (event == MobileAdEvent.closed) {
          Navigator.pop(context);
        }
      },
    );
  }

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static const String testDevice = "926A527EEB435B57EB0FEA5D24AEB425";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onBackPressed,
        child: Scaffold(
            backgroundColor: Colors.white30,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              title: Text("Episode ${widget.videoDocument['id']}"),
              centerTitle: true,
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                YoutubePlayer(
                  context: context,
                  source: _getIdFromUrl(),
                  quality: YoutubeQuality.MEDIUM,
                  aspectRatio: 16 / 9,
                  callbackController: (controller) {
                    _videoController = controller;
                  },
                  onVideoEnded: () {
                    _interstitialAd.show();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.videoDocument['title'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontFamily: "UID",
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )));
  }

  final List<RegExp> _regexps = [
    new RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
    new RegExp(
        r"^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$"),
    new RegExp(r"^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$")
  ];

  String _getIdFromUrl() {
    String url = widget.videoDocument['url'];
    if (url == null || url.length == 0) return null;

    url = url.trim();

    print(url);

    for (var exp in _regexps) {
      Match match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1);
    }
    return null;
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  // ignore: missing_return
  Future<bool> _onBackPressed() {
    _videoController?.pause();
    _interstitialAd?.show();
  }
}
