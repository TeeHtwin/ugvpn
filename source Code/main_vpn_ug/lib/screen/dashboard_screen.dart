import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mightyvpn/component/bandwidth_component.dart';
import 'package:mightyvpn/component/duration_component.dart';
import 'package:mightyvpn/component/ip_component.dart';
import 'package:mightyvpn/component/status_component.dart';
import 'package:mightyvpn/component/vpn_component.dart';
import 'package:mightyvpn/main.dart';
import 'package:mightyvpn/screen/server_list_screen.dart';
import 'package:mightyvpn/utils/cached_network_image.dart';
import 'package:mightyvpn/utils/colors.dart';
import 'package:mightyvpn/utils/common.dart';
import 'package:mightyvpn/utils/constant.dart';
import 'package:mightyvpn/utils/enums.dart';
import 'package:mightyvpn/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key})
      : super(key: key);

  @override
  _DashboardScreenState createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {
  InterstitialAd? myInterstitial;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    initializeStream();
    loadInterstitialAd();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: kReleaseMode
          ? mAdMobInterstitialId
          : InterstitialAd.testAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          myInterstitial = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          myInterstitial = null;
        },
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (myInterstitial == null) {
      print(
          'Warning: attempt to show interstitial before loaded.');
      return;
    }
    myInterstitial!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent:
          (InterstitialAd ad) => print(
              'ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent:
          (InterstitialAd ad) {
        ad.dispose();
        loadInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (InterstitialAd ad, AdError error) {
        ad.dispose();
        loadInterstitialAd();
      },
    );
    myInterstitial!.show();
    myInterstitial = null;
  }

  @override
  void dispose() {
    stageStream.cancel();
    myInterstitial!.dispose();
    dataStream.cancel();
    super.dispose();
  }

  void startVPN() {
    appStore.setLoading(true);
    vpnServicesMethods
        .startVpn(
            server: appStore.mSelectedServerModel)
        .then((value) {
      initializeStream();
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  void prepareVPN() {
    vpnServicesMethods.prepareVpn().then(
      (value) {
        log(value);
        if (value == "0") {
          toast("VPN Permission Denied");
          vpnStore.setIsPrepared(false,
              initialize: true);
        } else if (value == "-1") {
          toast("VPN Permission Granted");
          vpnStore.setIsPrepared(true,
              initialize: true);
        } else if (value == "1") {
          vpnStore.setIsPrepared(true,
              initialize: true);
          startVPN();
        }
      },
    ).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> stopVpn() async {
    await vpnServicesMethods
        .stopVpn()
        .then((value) {
      toast(language.lblDisconnect);
      showInterstitialAd();
      appStore.setLoading(false);
    }).catchError((e) {
      toast(e.toString());
    });
    vpnStore.setVPNStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstant.appName,
            style: boldTextStyle(
                color: Colors.grey, size: 20)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
      ),
      drawer: Drawer(
        elevation: 20,
        backgroundColor: Colors.transparent,
        child: Container(
            color: Colors.white,
            width: 250,
            child: Column(
              children: [
                35.height,
                ListTile(
                  leading: Image.asset(
                    vpnLogo,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    'UG VPN',
                    style: boldTextStyle(
                        color: Colors.grey),
                  ),
                ),
                Divider(color: Colors.black38),
                Expanded(
                  child: ListView(
                    padding:
                        const EdgeInsets.only(
                            left: 30, right: 0),
                    children: [
                      Text('Main',
                          style: boldTextStyle()),
                      10.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading:
                              Icon(Icons.home),
                          title: Text('Home'),
                        ),
                        color: primaryColor
                            .withOpacity(0.3),
                      ),
                      5.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading:
                              Icon(Icons.speed),
                          title:
                              Text('Speed Test'),
                        ),
                      ),
                      5.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(
                              Icons.settings),
                          title: Text(
                              'Click to donate'),
                        ),
                      ),
                      5.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(
                              Icons.leaderboard),
                          title:
                              Text('Leaderboard'),
                        ),
                      ),

                      // Othe
                      Divider(),
                      20.height,
                      Text('User',
                          style: boldTextStyle()),
                      10.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading:
                              Icon(Icons.person),
                          title: Text('Profile'),
                        ),
                        color: primaryColor
                            .withOpacity(0.3),
                      ),
                      5.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(
                              Icons.settings),
                          title: Text('Settings'),
                        ),
                      ),
                      5.height,
                      Card(
                        margin:
                            const EdgeInsets.only(
                                right: 0),
                        elevation: 0,
                        child: ListTile(
                          leading: Icon(
                            Icons.star_rounded,
                            color: Colors.amber,
                          ),
                          title: Text(
                              'Purchase Premium'),
                        ),
                      ),
                      5.height,
                    ],
                  ),
                )
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.center,
          mainAxisAlignment:
              MainAxisAlignment.start,
          children: [
            16.height,
            const IpComponent(),
            66.height,
            Observer(
              builder: (_) {
                return VpnComponent(
                  vpnStatus: vpnStore.vpnStatus ==
                      VPNStatus.connected,
                  onStartTapped: () async {
                    HapticFeedback.heavyImpact();
                    if (vpnStore.vpnStatus ==
                        VPNStatus.disconnected) {
                      if (!vpnStore.mIsPrepared) {
                        prepareVPN();
                      } else {
                        startVPN();
                      }
                    } else {
                      stopVpn();
                    }
                  },
                  onTapped: () {
                    showConfirmDialogCustom(
                      context,
                      dialogType:
                          DialogType.DELETE,
                      dialogAnimation:
                          DialogAnimation.SCALE,
                      positiveText:
                          language.lblDisconnect,
                      title: language
                          .lblWouldYouLikeToCancelTheCurrentVPNConnection,
                      onAccept: (c) async {
                        HapticFeedback
                            .heavyImpact();
                        await stopVpn();
                      },
                    );
                  },
                );
              },
            ),
            60.height,
            Observer(
                builder: (_) => Loader()
                    .visible(appStore.isLoading)),
            16.height,
            const StatusComponent(),
            8.height,
            const DurationComponent(),
            36.height,
            const BandwidthComponent(),
            60.height,
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                  language.lblCurrentServer,
                  style: boldTextStyle()),
            ).paddingSymmetric(horizontal: 26),
            8.height,
            Observer(
              builder: (_) => SettingItemWidget(
                radius: radius(),
                decoration: boxDecorationDefault(
                    borderRadius: radius(),
                    color: context.cardColor,
                    boxShadow: defaultBoxShadow(
                        blurRadius: 0,
                        spreadRadius: 0)),
                title: appStore
                    .mSelectedServerModel.country
                    .validate(),
                titleTextStyle: boldTextStyle(
                    color: primaryColor),
                leading: cachedImage(
                    appStore.mSelectedServerModel
                        .flagUrl
                        .validate(
                            value:
                                'assets/images/vpn_logo.png'),
                    width: 34,
                    height: 34),
                onTap: () {
                  push(const ServerListScreen(),
                      pageRouteAnimation:
                          PageRouteAnimation
                              .SlideBottomTop,
                      duration: 250.milliseconds);
                },
              ).paddingSymmetric(horizontal: 26),
            ),
            16.height,
          ],
        ),
      ),
    );
  }
}
