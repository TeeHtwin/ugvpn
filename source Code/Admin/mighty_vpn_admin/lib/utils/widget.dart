import 'package:flutter/material.dart';
import 'package:mighty_vpn_admin/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

InputDecoration inputDecoration({String? labelText,Icon?icon}) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: secondaryTextStyle(),
    prefixIcon: icon,
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor), borderRadius: radius()),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: viewLineColor), borderRadius: radius()),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor), borderRadius: radius()),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(color: errorColor), borderRadius: radius()),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: viewLineColor), borderRadius: radius()),
  );
}
