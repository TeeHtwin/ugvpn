import 'package:flutter/material.dart';
import 'package:mightyvpn/main.dart';
import 'package:mightyvpn/utils/colors.dart';
import 'package:mightyvpn/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class ThemeScreen extends StatefulWidget {
  @override
  _ThemeScreenState createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  int? currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    currentIndex = getIntAsync(THEME_MODE_INDEX);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  String _getName(ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return language.lblLight;
      case ThemeModes.Dark:
        return language.lblDark;
      case ThemeModes.SystemDefault:
        return language.lblSystemDefault;
    }
  }

  Widget _getIcons(BuildContext context, ThemeModes themeModes) {
    switch (themeModes) {
      case ThemeModes.Light:
        return Icon(LineIcons.sun, color: context.iconColor);
      case ThemeModes.Dark:
        return Icon(LineIcons.moon, color: context.iconColor);
      case ThemeModes.SystemDefault:
        return Icon(LineIcons.sun, color: context.iconColor);
    }
  }

  Color? getSelectedColor(int index) {
    if (currentIndex == index && appStore.isDarkMode) {
      return primaryColor.withOpacity(0.2);
    } else if (currentIndex == index && !appStore.isDarkMode) {
      return primaryColor.withOpacity(0.1);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblSelectYourTheme,
        showBack: true,
        elevation: 0,
        color: context.scaffoldBackgroundColor,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(
            ThemeModes.values.length,
            (index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: radius(),
                  color: getSelectedColor(index),
                  border: Border.all(color: context.dividerColor),
                ),
                width: context.width() / 2 - 24,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Text(_getName(ThemeModes.values[index]), style: boldTextStyle()).expand(),
                    _getIcons(context, ThemeModes.values[index]),
                  ],
                ),
              ).onTap(() async {
                currentIndex = index;
                if (index == AppThemeMode.themeModeSystem) {
                  appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
                } else if (index == AppThemeMode.themeModeLight) {
                  appStore.setDarkMode(false);
                } else if (index == AppThemeMode.themeModeDark) {
                  appStore.setDarkMode(true);
                }
                setValue(THEME_MODE_INDEX, index);
                setState(() {});
              }, borderRadius: radius());
            },
          ),
        ),
      ),
    );
  }
}
