import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mighty_vpn_admin/component/stacked_background.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/model/serverModel.dart';
import 'package:mighty_vpn_admin/utils/colors.dart';
import 'package:mighty_vpn_admin/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class AddServerScreen extends StatefulWidget {
  ServerModel? updateData;

  AddServerScreen({this.updateData, Key? key}) : super(key: key);

  @override
  _AddServerScreenState createState() => _AddServerScreenState();
}

class _AddServerScreenState extends State<AddServerScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController flagCont = TextEditingController();
  TextEditingController ovpnFileCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode flagFocus = FocusNode();
  FocusNode fileNameFocus = FocusNode();
  FocusNode usernameFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  String fileName = '';
  String filePath = '';

  FilePickerResult? countryFlagImage;
  FilePickerResult? selectedOvpnFile;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    isUpdate = widget.updateData != null;
    if (isUpdate) {
      nameCont.text = widget.updateData!.name!;
      flagCont.text = widget.updateData!.flag!;
      ovpnFileCont.text = widget.updateData!.ovpnFile!;
      userNameCont.text = widget.updateData!.userName!;
      passwordCont.text = widget.updateData!.password!;
    }
  }

  void submit() async {
    if (appStore.isTester) {
      toast("Test user cannot perform this action");
      return;
    }
    ServerModel data = ServerModel();

    data.name = nameCont.text;
    data.ovpnFile = ovpnFileCont.text;
    data.userName = userNameCont.text;
    data.password = passwordCont.text;
    data.isActive = true;
    data.createdAt = Timestamp.now();
    data.updatedAt = Timestamp.now();

    appStore.setIsLoading(true);

    if (countryFlagImage != null) {
      String imageUrl =
          await userService.getUploadedImageURLFromWeb(image: countryFlagImage!.files.first.bytes!, path: "flags", fileName: nameCont.text.toLowerCase(), extension: countryFlagImage!.files.first.extension!);
      data.flag = imageUrl;
    }
    if (selectedOvpnFile != null) {
      String imageUrl = await userService.getUploadedImageURLFromWeb(image: selectedOvpnFile!.files.first.bytes!, path: "ovpn", fileName: nameCont.text.toLowerCase(), extension: selectedOvpnFile!.files.first.extension!);
      data.ovpnFile = imageUrl;
    }

    serverService.addServiceDocument(data).then((value) {
      finish(context);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setIsLoading(false));
  }

  void updateSubmit() async {
    if (appStore.isTester) {
      toast("Test user cannot perform this action");
      return;
    }
    ServerModel data = ServerModel();
    data.uid = widget.updateData!.uid;
    data.name = nameCont.text;
    data.userName = userNameCont.text;
    data.password = passwordCont.text;
    data.isActive = widget.updateData!.isActive;
    data.createdAt = widget.updateData!.createdAt;
    data.updatedAt = Timestamp.now();

    appStore.setIsLoading(true);

    if (countryFlagImage != null) {
      String imageUrl =
          await userService.getUploadedImageURLFromWeb(image: countryFlagImage!.files.first.bytes!, path: "flags", fileName: nameCont.text.toLowerCase(), extension: countryFlagImage!.files.first.extension!);
      data.flag = imageUrl;
    } else {
      data.flag = widget.updateData!.flag;
    }
    if (selectedOvpnFile != null) {
      String imageUrl = await userService.getUploadedImageURLFromWeb(image: selectedOvpnFile!.files.first.bytes!, path: "ovpn", fileName: nameCont.text.toLowerCase(), extension: selectedOvpnFile!.files.first.extension!);
      data.ovpnFile = imageUrl;
    } else {
      data.ovpnFile = widget.updateData!.ovpnFile;
    }

    serverService.updateDocument(data.toJson(), widget.updateData!.uid!).then((value) {
      finish(context);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setIsLoading(false));
  }

  Future<FilePickerResult?> getOvpnFiles({String? message}) async {
    return await FilePicker.platform.pickFiles(type: FileType.custom, dialogTitle: message, allowedExtensions: ["ovpn"]);
  }

  Future<FilePickerResult?> getFiles({String? message}) async {
    return await FilePicker.platform.pickFiles(type: FileType.image, dialogTitle: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: StackedBackground(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              width: context.width() * 0.3,
              padding: EdgeInsets.all(16),
              decoration: boxDecorationDefault(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(appImages.appIcon, height: 100, fit: BoxFit.cover).center(),
                  16.height,
                  Text(isUpdate ? 'Update OVPN Server' : 'Add OVPN Server', style: boldTextStyle()).center(),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: nameCont,
                    nextFocus: flagFocus,
                    onFieldSubmitted: (s) {
                      setState(() {});
                    },
                    decoration: inputDecoration(labelText: 'Server Name', icon: Icon(Icons.web_asset)),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: flagCont,
                    readOnly: true,
                    decoration: inputDecoration(labelText: 'Country Flag', icon: Icon(Icons.flag)).copyWith(
                      suffixIcon: AppButton(
                        text: 'Select',
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                        onTap: () async {
                          countryFlagImage = await getFiles(message: "Select Country Flag");
                          if (countryFlagImage != null) {
                            flagCont.text = "Flag selected";
                            setState(() {});
                          }
                        },
                      ).paddingRight(8),
                    ),
                  ),
                  if (countryFlagImage != null) Image.memory(countryFlagImage!.files.first.bytes!, height: 60, width: 60),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: ovpnFileCont,
                    readOnly: true,
                    decoration: inputDecoration(labelText: 'OVPN Configuration Scripts', icon: Icon(Icons.info)).copyWith(
                      suffixIcon: AppButton(
                        text: 'Select',
                        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 16),
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(defaultRadius)),
                        onTap: () async {
                          selectedOvpnFile = await getOvpnFiles(message: "Select Ovpn Files");
                          if (selectedOvpnFile != null) {
                            ovpnFileCont.text = "OVPN Configuration selected";
                            setState(() {});
                          }
                        },
                      ).paddingRight(8),
                    ),
                    maxLines: null,
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: userNameCont,
                    nextFocus: passwordFocus,
                    decoration: inputDecoration(labelText: 'VPN Username', icon: Icon(Icons.vpn_key)),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.PASSWORD,
                    controller: passwordCont,
                    focus: passwordFocus,
                    decoration: inputDecoration(labelText: 'VPN Password', icon: Icon(Icons.vpn_lock)),
                  ),
                  16.height,
                  AppButton(
                    text: 'Submit',
                    width: context.width(),
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(16)),
                    onTap: () {
                      if (isUpdate) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          showConfirmDialogCustom(
                            context,
                            title: "Are you sure you want to update ${nameCont.text} server?",
                            dialogType: DialogType.UPDATE,
                            onAccept: (c) {
                              updateSubmit();
                            },
                          );
                        }
                      } else {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          showConfirmDialogCustom(
                            context,
                            title: "Are you sure you want to add ${nameCont.text} server?",
                            dialogType: DialogType.ADD,
                            onAccept: (c) {
                              submit();
                            },
                          );
                        }
                      }
                    },
                  ),
                ],
              ).center(),
            ),
          ),
        ),
      ),
    );
  }
}
