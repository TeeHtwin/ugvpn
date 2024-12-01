import 'package:mightyvpn/model/server_model.dart';
import 'package:mightyvpn/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

const appName = 'Anonymous VPN';

const iconSize = 26.0;
const textSize = 16.0;

const mAdMobAppId = 'your_AdMobAppId';
const mAdMobBannerId = 'your_AdMobBannerId';
const mAdMobInterstitialId =
    'your_AdMobInterstitialId';

const mRevenueCatKey = 'your_RevenueCatKey';

class AppConstant {
  static const appName = 'UG VPN';
  static const appDescription =
      'UG VPN is a very fast hiper protocol connector for you !';
  static const splashText = "FIGHT FOR FREEDOM";
  static const version = "1.0.0";
  static const defaultLanguage = 'en';
  static ServerModel defaultServer = ServerModel(
      country: 'Japan',
      ovpn: 'japan',
      ovpnUserName: 'vpn',
      ovpnUserPassword: 'vpn',
      flagUrl: LanguageImages.icJapanese);
}

class AppThemeMode {
  static const themeModeSystem = 0;
  static const themeModeLight = 1;
  static const themeModeDark = 2;
}

class VpnConstants {
  //Native Event Name
  static const String eventStage =
      'com.mighty.vpn/vpnStage';
  static const String eventData =
      'com.mighty.vpn/vpnData';
  static const String methodChannelName =
      'vpn_channel';

  // Native Method Name
  static const String prepareVpn = 'prepareVpn';
  static const String startVpn = 'startVpn';
  static const String updateVpn = 'updateVpn';
  static const String stopVpn = 'stopVpn';
  static const String fromServer = 'fromServer';

  static const String connecting = 'Connecting';
  static const String wait =
      'Waiting for server reply';
  static const String auth = 'Authenticating';
  static const String getConfig =
      'Getting client configuration';
  static const String assignIp =
      'Assigning IP addresses';
  static const String addRoutes = 'Adding routes';
  static const String connected = 'Connected';
  static const String disconnected = 'Disconnect';
  static const String reconnecting =
      'Reconnecting';
  static const String exiting = 'Exiting';
  static const String resolve = 'Not running';
  static const String tcpConnect =
      'Resolving host names';
  static const String noNetwork =
      'Not Connected to network';
  static const String connectRetry = 'Retrying';
  static const String authPending =
      'Connecting (TCP)';
  static const String userPause =
      'Connection paused';
  static const String notConnected =
      'Not connected';
}

class SharedPrefKeys {
  static const selectedServer = 'selectedServer';
  static const vpnConnected = 'vpnConnected';
  static const vpnConnecting = 'vpnConnecting';
  static const vpnDisconnected =
      'vpnDisconnected';
  static const vpnWaitConnection =
      'vpnWaitConnection';
  static const language = 'language';
  static const isPrepared = 'isPrepared';
}

class Urls {
  static const appDescription = "";
  static String copyRight =
      'copyright @${DateTime.now().year} ${AppConstant.appName}';
  static const packageName = "com.mighty.vpn";
  static const privacyPolicy =
      "https://www.google.com/";
  static const termsAndConditionURL =
      'https://www.google.com/';
  static const supportURL =
      'https://mighty.desky.support/';
  static const appShareURL =
      '$playStoreBaseURL$packageName';
  static const mailto = '';
  static const purchaseUrl =
      'https://codecanyon.net/user/meetmighty/portfolio?direction=desc&order_by=sortable_at&view=grid';
  static const documentation =
      'https://meetmighty.com/codecanyon/document/mightyvpn/';
}
