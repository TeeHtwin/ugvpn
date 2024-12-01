import 'package:mighty_vpn_admin/main.dart';
import 'package:mighty_vpn_admin/model/user_model.dart';
import 'package:mighty_vpn_admin/services/base_service.dart';
import 'package:mighty_vpn_admin/services/keys.dart';
import 'package:mighty_vpn_admin/utils/constants.dart';

class UserService extends BaseService<UserModel> {
  UserService() {
    ref = fireStore.collection(collections.user).withConverter<UserModel>(
          fromFirestore: (snapshot, options) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, options) => value.toJson(),
        );
  }

  Future<UserModel> userByEmail(String? email) async {
    return ref!.limit(1).where(userKeys.email, isEqualTo: email).get().then((value) => value.docs.first.data());
  }

  Stream<UserModel> getSettings() {
    return ref!.limit(1).where(userKeys.uid, isEqualTo: appStore.uid).snapshots().map((event) => event.docs.first.data());
  }

  Future<UserModel> getUser({String? email}) {
    return ref!.where(userKeys.email, isEqualTo: email).limit(1).get().then(
      (value) {
        if (value.docs.length == 1) {
          if (value.docs.first.data().userRole != "admin") {
            throw accessDenied;
          }
          return value.docs.first.data();
        } else {
          throw userNotFound;
        }
      },
    );
  }
}
