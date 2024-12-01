import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_vpn_admin/component/serverlist_component.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/screen/add_server_screen.dart';
import 'package:mighty_vpn_admin/screen/change_password_screen.dart';
import 'package:mighty_vpn_admin/screen/edit_profile_screen.dart';
import 'package:mighty_vpn_admin/utils/cached_network_image.dart';
import 'package:mighty_vpn_admin/utils/constants.dart';
import 'package:mighty_vpn_admin/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: context.scaffoldBackgroundColor,
        leading: Image.asset(
          appImages.appIcon,
          height: 65,
          width: 65,
        ),
        title: Text(appNameAdmin, style: boldTextStyle()),
        actions: [
          PopupMenuButton(
            child: Row(
              children: [
                16.width,
                Observer(builder: (_) => Text(appStore.firstName.validate(), style: boldTextStyle())),
                16.width,
                cachedImage(appStore.photoUrl, fit: BoxFit.cover, height: 46, width: 46).cornerRadiusWithClipRRect(100),
                16.width,
              ],
            ),
            onSelected: (i) {
              switch (i) {
                case 1:
                  push(EditProfileScreen(), pageRouteAnimation: PageRouteAnimation.Scale);
                  break;
                case 2:
                  push(ChangePasswordScreen(), pageRouteAnimation: PageRouteAnimation.Scale);
                  break;
                case 3:
                  showConfirmDialogCustom(
                    context,
                    dialogType: DialogType.CONFIRMATION,
                    primaryColor: context.primaryColor,
                    title: "Are you sure you want to logout ? ",
                    onAccept: (c) {
                      authService.logout(context);
                    },
                  );
              }
            },
            itemBuilder: (BuildContext context) {
              List<PopupMenuItem> list = [];
              list.add(
                PopupMenuItem(value: 1, child: Text('Edit Profile', style: boldTextStyle())),
              );
              list.add(
                PopupMenuItem(value: 2, child: Text('Change Password', style: boldTextStyle())),
              );
              list.add(
                PopupMenuItem(value: 3, child: Text('Logout', style: boldTextStyle())),
              );
              return list;
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(bottom: 60),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Server List', style: boldTextStyle()).expand(),
                TextIcon(
                  textStyle: boldTextStyle(),
                  text: "Add Server",
                  prefix: Icon(Icons.add, color: Colors.black, size: 20),
                  onTap: () {
                    push(AddServerScreen(), pageRouteAnimation: PageRouteAnimation.Scale, duration: 400.milliseconds);
                  },
                ),
              ],
            ).paddingAll(26),
            AppTextField(
              textFieldType: TextFieldType.NAME,
              controller: searchCont,
              onChanged: (s) {
                appStore.setSearchString(s);
              },
              decoration: inputDecoration(labelText: 'Search Server').copyWith(prefixIcon: Icon(Icons.search, size: 24)),
            ).paddingSymmetric(horizontal: 26),
            16.height,
            ServerListComponentWidget()
          ],
        ),
      ),
    );
  }
}
