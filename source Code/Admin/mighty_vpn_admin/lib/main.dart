import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_vpn_admin/app_theme.dart';
import 'package:mighty_vpn_admin/screen/splash_screen.dart';
import 'package:mighty_vpn_admin/services/auth_services.dart';
import 'package:mighty_vpn_admin/services/server_services.dart';
import 'package:mighty_vpn_admin/services/user_services.dart';
import 'package:mighty_vpn_admin/store/app_store.dart';
import 'package:mighty_vpn_admin/utils/colors.dart';
import 'package:mighty_vpn_admin/utils/constants.dart';
import 'package:mighty_vpn_admin/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_strategy/url_strategy.dart';

AppStore appStore = AppStore();
FirebaseFirestore fireStore =
    FirebaseFirestore.instance;

AppImages appImages = AppImages();

UserService userService = UserService();
AuthService authService = AuthService();
ServerService serverService = ServerService();

FirebaseOptions _firebaseOptions =
    FirebaseOptions(
  apiKey:
      'AIzaSyBK2mizPAdEA66dKZCnvuk5mJDxDaPHh68',
  authDomain: 'ugvpn-e7fad.firebaseapp.com',
  projectId: 'ugvpn-e7fad',
  databaseURL:
      'https://ugvpn-e7fad-default-rtdb.firebaseio.com',
  appId:
      '1:444063930202:web:c0c8efa7d7f3d34ad4c563',
  messagingSenderId: '142403184475',
  measurementId: 'G-VZHV1XGDDX',
  storageBucket: 'ugvpn-e7fad.appspot.com',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setPathUrlStrategy();

  await Firebase.initializeApp(
      options: _firebaseOptions);

  defaultRadius = 16.0;
  defaultAppButtonRadius = 30.0;
  defaultLoaderAccentColorGlobal = primaryColor;
  appButtonBackgroundColorGlobal = appButtonColor;
  defaultAppButtonTextColorGlobal = primaryColor;
  passwordLengthGlobal = 1;

  await initialize();

  appStore.setLoggedIn(
      getBoolAsync(sharePrefKey.isLoggedIn));
  appStore.setFirstName(
      getStringAsync(sharePrefKey.firstName));
  appStore.setEmail(
      getStringAsync(sharePrefKey.email));
  appStore.setPhotoUrl(
      getStringAsync(sharePrefKey.photoUrl));
  appStore
      .setUid(getStringAsync(sharePrefKey.uid));
  appStore.setEmailLogin(
      getBoolAsync(sharePrefKey.isEmailLogin));
  appStore.setTester(
      getBoolAsync(sharePrefKey.isTester));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => MaterialApp(
        title: appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode
            ? ThemeMode.dark
            : ThemeMode.light,
        home: SplashScreen(),
        navigatorKey: navigatorKey,
      ),
    );
  }
}
