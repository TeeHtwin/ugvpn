import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mightyvpn/main.dart';
import 'package:mightyvpn/model/server_model.dart';
import 'package:mightyvpn/utils/cached_network_image.dart';
import 'package:mightyvpn/utils/colors.dart';
import 'package:mightyvpn/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ServerListScreen extends StatefulWidget {
  const ServerListScreen({Key? key})
      : super(key: key);

  @override
  _ServerListScreenState createState() =>
      _ServerListScreenState();
}

class _ServerListScreenState
    extends State<ServerListScreen> {
  int isSelected = 0;
  BannerAd? myBanner;

  @override
  void initState() {
    super.initState();
    print(
        'debug : Server Length => ${vpnStore.serverList.length}');
    init();
  }

  void init() async {
    isSelected = vpnStore.serverList.indexWhere(
        (element) =>
            element.uid ==
            appStore.mSelectedServerModel.uid);
    myBanner = buildBannerAd()..load();
  }

  @override
  void dispose() {
    myBanner!.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  BannerAd buildBannerAd() {
    return BannerAd(
      adUnitId: kReleaseMode
          ? mAdMobBannerId
          : BannerAd.testAdUnitId,
      size: AdSize.banner,
      listener:
          BannerAdListener(onAdLoaded: (ad) {
        //
      }),
      request: const AdRequest(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Scaffold(
        appBar: appBarWidget(
          language.lblServerList,
          showBack: true,
          elevation: 0,
          center: true,
          actions: [
            IconButton(
              onPressed: () {
                if (vpnStore
                        .serverList[isSelected]
                        .uid ==
                    appStore.mSelectedServerModel
                        .uid) {
                  toasty(
                    context,
                    language
                        .lblSameServerSelected,
                    gravity: ToastGravity.TOP,
                    borderRadius: radius(),
                    bgColor: context.cardColor,
                    duration: 3.seconds,
                    textColor:
                        textPrimaryColorGlobal,
                  );
                } else {
                  appStore.setSelectedServerModel(
                      vpnStore.serverList[
                          isSelected]);
                  toasty(
                    context,
                    "${language.lblServerChangedTo} ${vpnStore.serverList[isSelected].country}, ${language.lblPleaseWaitWhileReconnecting} ",
                    gravity: ToastGravity.TOP,
                    borderRadius: radius(),
                    bgColor: context.cardColor,
                    duration: 3.seconds,
                    textColor:
                        textPrimaryColorGlobal,
                  );
                  vpnServicesMethods.updateVpn(
                      server: vpnStore.serverList[
                          isSelected]);
                }

                finish(context);
              },
              icon: Icon(Icons.done,
                  color: context.iconColor),
            )
          ],
        ),
        bottomNavigationBar: myBanner != null
            ? Container(
                height: AdSize.banner.height
                    .toDouble(),
                child: AdWidget(ad: myBanner!),
                color: Colors.white)
            : SizedBox(),
        body: Observer(
          builder: (_) => Container(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 16,
              runSpacing: 16,
              children: List.generate(
                vpnStore.serverList.length,
                (index) {
                  ServerModel data =
                      vpnStore.serverList[index];
                  bool selected =
                      isSelected == index;
                  return SettingItemWidget(
                    title:
                        data.country.validate(),
                    decoration: BoxDecoration(
                        color: context.cardColor,
                        borderRadius: radius()),
                    leading: cachedImage(
                        data.flagUrl.validate(
                            value:
                                'assets/images/vpn_logo.png'),
                        width: 34,
                        height: 34),
                    trailing: Row(
                      children: [
                        selected
                            ? Container(
                                padding:
                                    const EdgeInsets
                                        .all(6),
                                decoration: BoxDecoration(
                                    color: primaryColor
                                        .withOpacity(
                                            0.1),
                                    shape: BoxShape
                                        .circle,
                                    border: Border
                                        .all(
                                            color:
                                                primaryColor)),
                                child: const Icon(
                                    Icons.done,
                                    size: 16,
                                    color:
                                        primaryColor),
                              )
                            : Container(
                                padding:
                                    const EdgeInsets
                                        .all(14),
                                decoration: BoxDecoration(
                                    border: Border
                                        .all(
                                            color:
                                                primaryColor),
                                    shape: BoxShape
                                        .circle),
                              ),
                      ],
                    ),
                    onTap: () {
                      isSelected = index;
                      setState(() {});
                    },
                    radius: radius(),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }
}
