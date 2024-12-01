import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mighty_vpn_admin/component/stacked_background.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/model/user_model.dart';
import 'package:mighty_vpn_admin/services/keys.dart';
import 'package:mighty_vpn_admin/utils/cached_network_image.dart';
import 'package:mighty_vpn_admin/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController();
  TextEditingController fNameCont = TextEditingController();

  FocusNode emailNode = FocusNode();
  FocusNode fNameNode = FocusNode();

  String imageURL = "";

  FilePickerResult? image;

  UserModel? user;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    appStore.setIsLoading(true);
    await userService.getUser(email: appStore.email).then((value) {
      emailCont.text = value.email.validate();
      fNameCont.text = value.firstName.validate();
      imageURL = value.photoUrl.validate();
      user = value;
      setState(() {});
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setIsLoading(false));
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      appStore.setIsLoading(true);

      Map<String, dynamic> request = {
        userKeys.uid: user!.uid,
        userKeys.firstName: fNameCont.text,
        userKeys.email: user!.email,
        userKeys.isEmailLogin: user!.isEmailLogin,
        userKeys.createdAt: user!.createdAt,
        userKeys.updatedAt: Timestamp.now(),
      };

      if (image != null) {
        String imageUrl = await userService.getUploadedImageURLFromWeb(image: image!.files.first.bytes!, path: "profile", fileName: user!.uid!, extension: image!.files.first.extension!);
        request.putIfAbsent(userKeys.photoUrl, () => imageUrl);
        user!.photoUrl = imageUrl;
      } else {
        request.putIfAbsent(userKeys.photoUrl, () => user!.photoUrl);
      }
      log(request);
      userService.updateDocument(request, user!.uid).then((value) {
        toast("Updated");
        appStore.setFirstName(fNameCont.text.validate(), isInitializing: true);
        appStore.setPhotoUrl(user!.photoUrl.validate(), isInitializing: true);
        finish(context);
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setIsLoading(false));
    }
  }

  Future getImage() async {
    image = await FilePickerWeb.platform.pickFiles();
    setState(() {});
  }

  Widget buildProfileImage() {
    double height = 120;
    double width = 120;
    if (user != null) {
      if (image != null) {
        return Image.memory(image!.files.first.bytes!, fit: BoxFit.cover, height: height, width: width);
      } else if (user!.photoUrl != null && image == null) {
        return cachedImage(user!.photoUrl, fit: BoxFit.cover, height: height, width: width);
      }
    }
    return Image.asset(appImages.placeholder_image, fit: BoxFit.cover, height: height, width: width);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StackedBackground(
        child: SingleChildScrollView(
          child: Container(
            width: context.width() * 0.3,
            padding: EdgeInsets.all(16),
            decoration: boxDecorationDefault(),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Edit Profile', style: boldTextStyle(size: 24)),
                  32.height,
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(decoration: BoxDecoration(shape: BoxShape.circle), child: buildProfileImage()).cornerRadiusWithClipRRect(80),
                      Container(
                        decoration: boxDecorationDefault(shape: BoxShape.circle),
                        child: IconButton(
                          icon: Icon(Icons.camera_alt, size: 16),
                          onPressed: () {
                            getImage();
                          },
                        ),
                      )
                    ],
                  ).center(),
                  48.height,
                  AppTextField(
                    textFieldType: TextFieldType.EMAIL,
                    controller: emailCont,
                    nextFocus: fNameNode,
                    enabled: false,
                    decoration: inputDecoration(labelText: 'Email', icon: Icon(Icons.mail)),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: fNameCont,
                    focus: fNameNode,
                    decoration: inputDecoration(labelText: 'First Name', icon: Icon(Icons.person)),
                  ),
                  16.height,
                  AppButton(
                    width: context.width(),
                    text: 'Update Profile',
                    onTap: () {
                      showConfirmDialogCustom(
                        context,
                        title: "Are you sure you want to update profile details?",
                        dialogType: DialogType.UPDATE,
                        onAccept: (c) {
                          if (appStore.isTester) {
                            toast("Test user cannot perform this action");
                            return;
                          }
                          submit();
                        },
                      );
                    },
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(16)),
                  ),
                ],
              ),
            ),
          ).center(),
        ),
      ),
    );
  }
}
