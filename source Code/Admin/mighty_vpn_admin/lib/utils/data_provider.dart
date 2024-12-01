import 'package:mighty_vpn_admin/model/view_model.dart';
import 'package:mighty_vpn_admin/screen/change_password_screen.dart';
import 'package:mighty_vpn_admin/screen/home_screen.dart';

List<ViewModel> getViewModel() {
  List<ViewModel> list = [];
  list.add(ViewModel(view: HomeScreen()));
  list.add(ViewModel(view: ChangePasswordScreen()));

  return list;
}
