import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mightyvpn/main.dart';
import 'package:mightyvpn/model/server_model.dart';
import 'package:mightyvpn/screen/bottom_nav_bar.dart';
import 'package:mightyvpn/utils/colors.dart';
import 'package:mightyvpn/utils/common.dart';
import 'package:mightyvpn/utils/constant.dart';
import 'package:mightyvpn/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() =>
      SplashScreenState();
}

class SplashScreenState
    extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  bool _triggerLine = false;

  @override
  void initState() {
    super.initState();

    showStatusBar();

    init();
  }

  init() async {
    afterBuildCreated(
      () {
        setStatusBarColor(
            context.scaffoldBackgroundColor);

        appStore.setLanguage(
            getStringAsync(
                SharedPrefKeys.language,
                defaultValue:
                    AppConstant.defaultLanguage),
            context: context);
      },
    );
    animationController = AnimationController(
        vsync: this, duration: 1.seconds);
    animation = CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInQuad);
    animationController.forward();

    vpnStore.setVPNStatus();

    serverService.getServerList().listen((event) {
      vpnStore.serverList.clear();

      vpnStore.setServerList(event);

      print(
          'debug : Fucking Server List => ${event.length}');

      if (getStringAsync(
              SharedPrefKeys.selectedServer)
          .isEmpty) {
        // appStore
        //     .setSelectedServerModel(event.first);
      } else {
        appStore.setSelectedServerModel(
            ServerModel.fromJson(jsonDecode(
                getStringAsync(SharedPrefKeys
                    .selectedServer))));
      }
    });

    4.seconds.delay.then((value) {
      showConfirmDialogCustom(context,
          primaryColor: primaryColor,
          onCancel: (context) => push(
              const BottomNavBar(),
              isNewTask: true,
              pageRouteAnimation:
                  PageRouteAnimation.Fade),
          title:
              "ကျေးဇူးပြု၍ နိုင်ငံတစ်ခုသို့ VPN ချိတ်ပြီးမှ ၀င်ပေးပါခင်‌ဗျာ?",
          dialogType: DialogType.ACCEPT,
          positiveText: "Ok Thank",
          onAccept: (context) {
            push(const BottomNavBar(),
                isNewTask: true,
                pageRouteAnimation:
                    PageRouteAnimation.Fade);
          });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _triggerLine = true;
        });
      }
    });

    return Scaffold(
      // backgroundColor: Colors.grey,
      extendBody: true,
      extendBodyBehindAppBar: true,
      body: Stack(children: [
        Positioned(
          top: 0,
          right: 0,
          child: AnimatedSlide(
            duration: 2.seconds,
            offset: _triggerLine
                ? const Offset(0, 0)
                : const Offset(0, -1),
            child: Image.asset(
              'assets/extension_ug/line_two.png',
              fit: BoxFit.fitWidth,
              width: MediaQuery.of(context)
                      .size
                      .width *
                  0.4,
              height: MediaQuery.of(context)
                      .size
                      .height *
                  0.5,
            ),
          ),
        ),
        Positioned(
          top: 30,
          left: 0,
          right: 100,
          child: Container(
            alignment: Alignment.centerLeft,
            child: AnimatedSlide(
              duration: 3.seconds,
              offset: _triggerLine
                  ? const Offset(0, 0)
                  : const Offset(0, -1),
              child: Image.asset(
                'assets/extension_ug/line_one.png',
                fit: BoxFit.fitHeight,
                width: MediaQuery.of(context)
                        .size
                        .width *
                    0.5,
                height: MediaQuery.of(context)
                        .size
                        .height *
                    0.5,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                Spacer(),
                ScaleTransition(
                    scale: animation,
                    child: Image.asset(vpnLogo,
                        height: 230,
                        width: 180,
                        fit: BoxFit.cover)),
                Spacer(),
                Column(
                  children: [
                    Text(AppConstant.splashText,
                        textScaleFactor: 1.4,
                        style: boldTextStyle(
                            color:
                                appButtonColor)),
                    RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: 'Version',
                            style: boldTextStyle(
                                color: Colors
                                    .black45)),
                        TextSpan(
                            text:
                                ' ${AppConstant.version}',
                            style: boldTextStyle(
                                color:
                                    appButtonColor))
                      ]),
                    ),
                    50.height
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 100,
          top: 100,
          child: AnimatedOpacity(
              duration: 3.seconds,
              opacity: _triggerLine ? 1 : 0,
              child: Image.asset(
                  'assets/extension_ug/shwe_dagon.png',
                  fit: BoxFit.fitWidth,
                  height: 200)),
        )
      ]),
    );
  }
}
