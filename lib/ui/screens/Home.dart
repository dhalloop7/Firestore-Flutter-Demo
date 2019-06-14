import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:pelivaato/ui/items/VideoListItem.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String _appTitlePart1 = "Peli";
  final String _appTitlePart2 = "Vaato";

  BannerAd _bannerAd;

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

  static const MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    testDevices: testDevice != null ? <String>[testDevice] : null,
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    childDirected: true,
    nonPersonalizedAds: true,
  );

  static const String testDevice = "926A527EEB435B57EB0FEA5D24AEB425";

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance.initialize(
        appId: FirebaseAdMob.testAppId,
        analyticsEnabled: true,
        trackingId: testDevice);
    _bannerAd = createBannerAd()..load();
    _bannerAd.show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Text(
                  _appTitlePart1,
                  style: TextStyle(
                      color: Color(0xff0073AE),
                      fontSize: 24.0,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3.0),
                child: Text(
                  _appTitlePart2,
                  style: TextStyle(
                      color: Color(0xffE46433),
                      fontSize: 24.0,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold),
                ),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream:
              Firestore.instance.collection('videos').orderBy('id').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: new Text('Loading...'));
              default:
                return new ListView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: 50.0),
                  scrollDirection: Axis.vertical,
                  children:
                      snapshot.data.documents.map((DocumentSnapshot document) {
                    return VideoListItem(document);
                  }).toList(),
                );
            }
          },
        ));
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }
}
