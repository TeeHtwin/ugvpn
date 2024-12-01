import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/model/user_model.dart';
import 'package:mighty_vpn_admin/screen/signin_screen.dart';
import 'package:mighty_vpn_admin/services/keys.dart';
import 'package:mighty_vpn_admin/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

final googleSignIn = GoogleSignIn();

FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn().catchError((e) {
      log(e.toString());
    });

    if (googleSignInAccount != null) {
      setValue(sharePrefKey.isLoggedIn, true);

      //Authentication
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);

      await googleSignIn.signOut();
      await loginFromFirebaseUser(user);
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> loginFromFirebaseUser(User currentUser, {String? fullName}) async {
    UserModel userModel = UserModel();

    if (await userService.isUserExist(currentUser.email)) {
      ///Return user data
      await userService.userByEmail(currentUser.email).then((user) async {
        userModel = user;

        await updateUserData(user);
      }).catchError((e) {
        log(e);
        throw e;
      });
    } else {
      /// Create user
      userModel.email = currentUser.email;
      userModel.uid = currentUser.uid;
      userModel.photoUrl = currentUser.photoURL;
      log(currentUser.photoURL);
      userModel.isEmailLogin = false;

      userModel.createdAt = Timestamp.now();
      userModel.updatedAt = Timestamp.now();
      if (isIos) {
        userModel.firstName = fullName;
      } else {
        userModel.firstName = currentUser.displayName.validate();
      }

      log(userModel.toJson());

      await userService.addDocumentWithCustomId(currentUser.uid, userModel).then((value) {
        log("New User Added");
      }).catchError((e) {
        throw e;
      });
    }

    await setUserDetailPreference(userModel);
  }

  Future<void> updateUserData(UserModel user) async {
    userService.updateDocument({
      'updatedAt': Timestamp.now(),
    }, user.uid.validate());
  }

  Future<void> setUserDetailPreference(UserModel user) async {
    appStore.setLoggedIn(true, isInitializing: true);
    appStore.setFirstName(user.firstName.validate(), isInitializing: true);
    appStore.setEmail(user.email.validate(), isInitializing: true);
    appStore.setPhotoUrl(user.photoUrl.validate(), isInitializing: true);
    appStore.setUid(user.uid.validate(), isInitializing: true);
    appStore.setEmailLogin(user.isEmailLogin.validate(), isInitializing: true);
    appStore.setTester(user.isTester.validate(), isInitializing: true);
  }

  Future<void> signUpWithEmailPassword({required Map<String, dynamic> userData}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: userData[userKeys.email], password: userData[userKeys.password]);
    if (userCredential.user != null) {
      User currentUser = userCredential.user!;
      UserModel userModel = UserModel();

      userModel.email = currentUser.email;
      userModel.firstName = userData[userKeys.firstName];
      userModel.uid = currentUser.uid;
      userModel.isEmailLogin = userData[userKeys.isEmailLogin];
      userModel.photoUrl = userData[userKeys.photoUrl];
      userModel.isTester = userData[userKeys.isTester];
      userModel.userRole = userData[userKeys.userRole];
      userModel.createdAt = Timestamp.now();
      userModel.updatedAt = Timestamp.now();

      await userService.addDocumentWithCustomId(currentUser.uid, userModel).then((value) async {
        //
        // await signInWithEmailPassword(email: userData[userKeys.email], password: userData[userKeys.password]).then((value) {
        //   //
        // });
      }).catchError((e) {
        log(e);
        throw e;
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signInWithEmailPassword({required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      final User user = value.user!;
      UserModel userModel = await userService.getUser(email: user.email);
      setValue(sharePrefKey.password, password);
      await updateUserData(userModel);
      await setUserDetailPreference(userModel);
    }).catchError((error) async {
      if (!await isNetworkAvailable()) {
        throw 'Please check network connection';
      }
      if (error.toString() == accessDenied) {
        throw "You are not allowed to login in please contact admin to get access";
      }
      throw error.toString();
    });
  }

  Future<void> changePassword(String newPassword) async {
    await FirebaseAuth.instance.currentUser!.updatePassword(newPassword).then((value) async {
      await setValue(sharePrefKey.password, newPassword);
    });
  }

  Future<void> logout(BuildContext context) async {
    removeKey(sharePrefKey.isLoggedIn);
    removeKey(sharePrefKey.isEmailLogin);
    removeKey(sharePrefKey.firstName);
    removeKey(sharePrefKey.email);
    removeKey(sharePrefKey.photoUrl);
    removeKey(sharePrefKey.uid);
    removeKey(sharePrefKey.password);

    appStore.setLoggedIn(false);

    LoginScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Scale, isNewTask: true, duration: 450.milliseconds);
  }

  Future<void> forgotPassword({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email).then((value) {
      //
    }).catchError((error) {
      throw error.toString();
    });
  }
}
