import 'package:cake_away/Home/AdHelper.dart';
import 'package:cake_away/Home/RequestView.dart';
import 'package:cake_away/Home/choose.dart';
import 'package:cake_away/Home/favourite.dart';
import 'package:cake_away/Home/OfferView.dart';
import 'package:cake_away/Home/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:easy_localization/easy_localization.dart';

class Home extends StatefulWidget {
  Home({
    Key key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with AutomaticKeepAliveClientMixin<Home> {
  int _currentIndex = 0;
  BannerAd _ad;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
  }

  _createBannerAd() {
    _ad = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    );

    _ad.load();
  }

  final List<Widget> _children = [
    OfferView(),
    RequestView(),
    Choose(),
    Favourite(),
    Profile(),
  ];

  Widget showAdd() {
    if (_isAdLoaded) {
      return Container(
        child: AdWidget(ad: _ad),
        width: _ad.size.width.toDouble(),
        height: _ad.size.height.toDouble(),
        alignment: Alignment.center,
      );
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(child: _children[_currentIndex]),
          showAdd(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: "Offers".tr(),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            label: "Requests".tr(),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.add_circle_outline),
            label: "Post".tr(),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            label: "Favourites".tr(),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile".tr(),
          ),
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _ad.dispose();
    super.dispose();
  }
}
