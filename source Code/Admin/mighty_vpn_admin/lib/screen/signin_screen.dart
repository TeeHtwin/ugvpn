import 'package:flutter/material.dart';
import 'package:mighty_vpn_admin/component/forgot_password_component.dart';
import 'package:mighty_vpn_admin/component/stacked_background.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/screen/home_screen.dart';
import 'package:mighty_vpn_admin/screen/signup_screen.dart';
import 'package:mighty_vpn_admin/services/keys.dart';
import 'package:mighty_vpn_admin/utils/colors.dart';
import 'package:mighty_vpn_admin/utils/widget.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailCont = TextEditingController(text: 'john@gmail.com');
  TextEditingController passCont = TextEditingController(text: '123456');

  FocusNode userNameFocus = FocusNode();
  FocusNode passFocus = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  void submit() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      Map<String, dynamic> data = {
        userKeys.email: emailCont.text,
        userKeys.password: passCont.text,
      };

      appStore.setIsLoading(true);
      authService.signInWithEmailPassword(email: data[userKeys.email], password: data[userKeys.password]).then((value) {
        toasty(
          context,
          "Welcome Back ${appStore.firstName}",
          borderRadius: radius(),
          bgColor: appButtonColor,
          textColor: primaryColor,
          gravity: ToastGravity.TOP,
        );
        push(HomeScreen(), pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      }).catchError((e) {
        toast(e.toString());
      }).whenComplete(() => appStore.setIsLoading(false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: StackedBackground(
          showBackButton: false,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  width: context.width() * 0.3,
                  decoration: boxDecorationDefault(),
                  child: Column(
                    children: [
                      Image.asset(appImages.appIcon, height: 100, fit: BoxFit.cover).center(),
                      16.height,
                      Text("Sign In", style: boldTextStyle(size: 22)),
                      32.height,
                      AppTextField(
                        textFieldType: TextFieldType.NAME,
                        keyboardType: TextInputType.name,
                        controller: emailCont,
                        autoFocus: true,
                        nextFocus: passFocus,
                        decoration: inputDecoration(labelText: 'Email', icon: Icon(Icons.person)),
                      ),
                      16.height,
                      AppTextField(
                        controller: passCont,
                        textFieldType: TextFieldType.PASSWORD,
                        focus: passFocus,
                        decoration: inputDecoration(labelText: 'Password', icon: Icon(Icons.lock)),
                        onFieldSubmitted: (p0) {
                          submit();
                        },
                      ),
                      16.height,
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          child: Text('Forgot Password?', style: boldTextStyle(color: primaryColor, size: 12)),
                          onPressed: () {
                            showInDialog(
                              context,
                              builder: (_) => ForgotPasswordComponent(),
                              dialogAnimation: DialogAnimation.SLIDE_BOTTOM_TOP,
                            );
                          },
                        ),
                      ),
                      16.height,
                      AppButton(
                        width: context.width(),
                        text: 'Sign In',
                        shapeBorder: RoundedRectangleBorder(borderRadius: radius(16)),
                        onTap: () {
                          submit();
                        },
                      ),
                      8.height,
                    ],
                  ),
                ).center(),
                16.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: secondaryTextStyle(size: 14)),
                    8.width,
                    TextButton(
                      onPressed: () {
                        SignUpScreen().launch(context);
                      },
                      child: Text('Create Account Here', style: boldTextStyle()),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
