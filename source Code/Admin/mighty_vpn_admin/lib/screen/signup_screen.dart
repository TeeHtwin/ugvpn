import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mighty_vpn_admin/component/stacked_background.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/services/keys.dart';
import 'package:mighty_vpn_admin/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController fullNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();

  FocusNode firstNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode passFocus = FocusNode();
  FocusNode conformPassFocus = FocusNode();

  void submit() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Map<String, dynamic> data = {
        userKeys.firstName: fullNameCont.text,
        userKeys.email: emailCont.text,
        userKeys.photoUrl: "",
        userKeys.isEmailLogin: true,
        userKeys.password: passCont.text,
        userKeys.isTester: true,
        userKeys.userRole: "user",
        userKeys.createdAt: Timestamp.now(),
        userKeys.updatedAt: Timestamp.now(),
      };
      appStore.setIsLoading(true);
      if (await userService.isUserExist(emailCont.text)) {
        toast("User Already Exist, Please sign");
        appStore.setIsLoading(false);
        finish(context);
      } else {
        authService.signUpWithEmailPassword(userData: data).then((value) {
          finish(context);
        }).catchError((e) {
          toast(e.toString());
        }).whenComplete(() => appStore.setIsLoading(false));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: StackedBackground(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(top: 32),
          child: Container(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    width: context.width() * 0.3,
                    decoration: boxDecorationDefault(),
                    child: Column(
                      children: [
                        Image.asset('images/app_logo.png', height: 100, fit: BoxFit.cover).center(),
                        16.height,
                        Text('Sign Up', style: boldTextStyle(size: 22)).center(),
                        32.height,
                        AppTextField(
                          controller: fullNameCont,
                          textFieldType: TextFieldType.NAME,
                          keyboardType: TextInputType.name,
                          autoFocus: true,
                          nextFocus: emailFocus,
                          decoration: inputDecoration(labelText: 'Full Name', icon: Icon(Icons.person)),
                        ),
                        16.height,
                        AppTextField(
                          controller: emailCont,
                          textFieldType: TextFieldType.EMAIL,
                          keyboardType: TextInputType.emailAddress,
                          nextFocus: conformPassFocus,
                          decoration: inputDecoration(labelText: 'Email', icon: Icon(Icons.mail)),
                        ),
                        16.height,
                        AppTextField(
                          controller: passCont,
                          textFieldType: TextFieldType.PASSWORD,
                          nextFocus: conformPassFocus,
                          decoration: inputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
                          autoFillHints: [AutofillHints.newPassword],
                        ),
                        16.height,
                        AppTextField(
                          controller: confirmPassCont,
                          textFieldType: TextFieldType.PASSWORD,
                          focus: conformPassFocus,
                          validator: (String? value) {
                            if (value!.isEmpty) return errorThisFieldRequired;
                            if (value.length < passwordLengthGlobal) return 'Password length should be more than six';
                            if (value.trim() != passCont.text.trim()) return 'Both password should be matched';

                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (s) {
                            submit();
                          },
                          decoration: inputDecoration(labelText: 'Confirm Password', icon: Icon(Icons.lock)),
                        ),
                        16.height,
                        AppButton(
                          width: context.width(),
                          text: 'Sign Up',
                          onTap: () {
                            submit();
                          },
                          shapeBorder: RoundedRectangleBorder(borderRadius: radius(16)),
                        ),
                        8.height,
                      ],
                    ),
                  ).center(),
                  8.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account?", style: secondaryTextStyle(size: 14)),
                      8.width,
                      TextButton(
                        child: Text('Sign In Here', style: boldTextStyle()),
                        onPressed: () {
                          finish(context);
                        },
                      )
                    ],
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
