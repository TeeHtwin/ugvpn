import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/model/serverModel.dart';
import 'package:mighty_vpn_admin/screen/add_server_screen.dart';
import 'package:mighty_vpn_admin/services/keys.dart';
import 'package:mighty_vpn_admin/utils/cached_network_image.dart';
import 'package:mighty_vpn_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class ServerListComponentWidget extends StatefulWidget {
  const ServerListComponentWidget({Key? key}) : super(key: key);

  @override
  _ServerListComponentWidgetState createState() => _ServerListComponentWidgetState();
}

class _ServerListComponentWidgetState extends State<ServerListComponentWidget> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

  void deleteServer(ServerModel data) {
    showConfirmDialogCustom(
      context,
      dialogType: DialogType.DELETE,
      dialogAnimation: DialogAnimation.SCALE,
      onAccept: (c) async {
        if (data.ovpnFile.validate().isNotEmpty) {
          serverService.deleteImage(data.ovpnFile!).catchError((e) {});
        }
        if (data.flag.validate().isNotEmpty) {
          serverService.deleteImage(data.flag!).catchError((e) {});
        }

        serverService.removeDocument(data.uid.validate()).then((value) async {
          toast("${data.name} server Deleted");
        }).catchError((e) {
          toast(e.toString(), print: true);
        });
      },
    );
  }

  List<Widget> buildDataRow(List<ServerModel> data) {
    log(data.length);
    if (data.length == 0) {
      return [
        Text('No Data Found', style: boldTextStyle()).paddingAll(16).center(),
      ];
    }
    return List.generate(
      data.length,
      (index) {
        ServerModel serverData = data[index];

        return Row(
          children: [
            Text("#${index + 1}", style: primaryTextStyle(size: 14), textAlign: TextAlign.center).expand(),
            Text(serverData.name.validate().capitalizeFirstLetter(), style: primaryTextStyle(size: 14), textAlign: TextAlign.center).expand(flex: 3),
            cachedImage(serverData.flag.validate(), height: 50, width: 50, radius: 0).paddingSymmetric(vertical: 4).expand(flex: 3),
            Text(serverData.userName.validate(), style: primaryTextStyle(size: 14), textAlign: TextAlign.center).expand(flex: 3),
            Text(serverData.password.validate(), style: primaryTextStyle(size: 14), textAlign: TextAlign.center).expand(flex: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.all(4),
                  icon: Icon(Icons.edit, color: primaryColor),
                  onPressed: () {
                    push(AddServerScreen(updateData: serverData), pageRouteAnimation: PageRouteAnimation.Fade);
                  },
                ),
                IconButton(
                  padding: EdgeInsets.all(4),
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    if (appStore.isTester) {
                      toast("Test user cannot perform this action");
                      return;
                    }
                    deleteServer(serverData);
                  },
                )
              ],
            ).center().expand(flex: 3),
            Transform.scale(
              scale: 0.8,
              child: CupertinoSwitch(
                value: serverData.isActive.validate(value: false),
                onChanged: (bool value) {
                  if (appStore.isTester) {
                    toast("Test user cannot perform this action");
                    return;
                  }
                  Map<String, dynamic> request = {serverKey.isActive: value};

                  serverService.updateDocument(request, serverData.uid).then((v) {
                    toast("${serverData.name} server is now ${value ? 'active' : 'inactive'}");
                  }).catchError((e) {
                    toast(e.toString());
                  });
                },
              ),
            ).expand(flex: 3),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ServerModel>>(
      stream: serverService.getServerList(),
      builder: (context, snap) {
        return Observer(
          builder: (_) => Container(
            decoration: boxDecorationDefault(),
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.only(bottom: 16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(borderRadius: radiusOnly(topRight: 16, topLeft: 16), color: appButtonColor),
                  child: Row(
                    children: [
                      Text("No", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(),
                      Text("Name", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(flex: 3),
                      Text("Flag", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(flex: 3),
                      Text("Username", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(flex: 3),
                      Text("Password", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(flex: 3),
                      Text("Actions", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(flex: 3),
                      Text("Status", style: boldTextStyle(color: primaryColor), textAlign: TextAlign.center).center().expand(flex: 3),
                    ],
                  ),
                ),
                16.height,
                if (!snap.hasData) Loader().center(),
                if (snap.hasData)
                  ...buildDataRow(
                    appStore.searchString.isEmpty ? snap.data! : snap.data!.where((element) => element.name!.toLowerCase().contains(appStore.searchString.toLowerCase())).toList(),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}
