import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mighty_vpn_admin/main.dart';
import 'package:nb_utils/nb_utils.dart';

class StackedBackground extends StatelessWidget {
  final Widget child;
  final bool showBackButton;

  StackedBackground({required this.child, this.showBackButton = true});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(appImages.singingBackground, fit: BoxFit.cover, height: context.height(), width: context.width()),
        child.center(),
        if (showBackButton)
          Positioned(
            top: 16,
            left: 16,
            child: BackButton(
              onPressed: () {
                finish(context);
              },
            ),
          ),
        Observer(builder: (context) => Loader().visible(appStore.isLoading)),
      ],
    );
  }
}
