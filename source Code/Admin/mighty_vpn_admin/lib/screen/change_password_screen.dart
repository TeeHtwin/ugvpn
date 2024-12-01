import 'package:flutter/material.dart';
import 'package:mighty_vpn_admin/component/stacked_background.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/utils/constants.dart';
import 'package:mighty_vpn_admin/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController confirmPasswordCont = TextEditingController();

  FocusNode oldPassNode = FocusNode();
  FocusNode newPasswordNode = FocusNode();
  FocusNode confirmPasswordNode = FocusNode();

  final formKey = GlobalKey<FormState>();

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (appStore.isTester) {
        toast("Test user cannot perform this action");
        return;
      }
      appStore.setIsLoading(true);
      authService.changePassword(newPasswordCont.text).then((value) {
        finish(context);
        toast('Your new password has been changed');
      })
        ..catchError((e) {
          log('error string');
          log(e.toString());
        }).whenComplete(() => appStore.setIsLoading(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: StackedBackground(
          child: SingleChildScrollView(
            child: Container(
              width: context.width() * 0.3,
              padding: EdgeInsets.all(16),
              decoration: boxDecorationDefault(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(appImages.appIcon, height: 100, fit: BoxFit.cover).center(),
                  16.height,
                  Text('Change Password', style: boldTextStyle()),
                  16.height,
                  AppTextField(
                    controller: oldPasswordCont,
                    focus: oldPassNode,
                    textFieldType: TextFieldType.PASSWORD,
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      if (s.trim() != getStringAsync(sharePrefKey.password)) return "Old password is wrong";
                    },
                    nextFocus: newPasswordNode,
                    decoration: inputDecoration(labelText: 'Old Password', icon: Icon(Icons.lock)),
                  ),
                  16.height,
                  AppTextField(
                    controller: newPasswordCont,
                    focus: newPasswordNode,
                    textFieldType: TextFieldType.PASSWORD,
                    nextFocus: confirmPasswordNode,
                    decoration: inputDecoration(labelText: 'New Password', icon: Icon(Icons.lock)),
                  ),
                  16.height,
                  AppTextField(
                    controller: confirmPasswordCont,
                    textFieldType: TextFieldType.PASSWORD,
                    focus: confirmPasswordNode,
                    validator: (s) {
                      if (s!.trim().isEmpty) return errorThisFieldRequired;
                      if (s.trim() != newPasswordCont.text) return "Confirm password must be as new password";
                    },
                    onFieldSubmitted: (s) {
                      submit();
                    },
                    decoration: inputDecoration(labelText: 'Confirm Password', icon: Icon(Icons.lock)),
                  ),
                  16.height,
                  AppButton(
                    width: context.width(),
                    text: 'Submit',
                    shapeBorder: RoundedRectangleBorder(borderRadius: radius(16)),
                    onTap: () {
                      submit();
                    },
                  ),
                ],
              ),
            ).center(),
          ),
        ),
      ),
    );
  }
}
