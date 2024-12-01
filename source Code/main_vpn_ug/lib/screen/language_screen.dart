import 'package:flutter/material.dart';
import 'package:mightyvpn/main.dart';
import 'package:mightyvpn/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageScreenState createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  Color? getSelectedColor(LanguageDataModel data) {
    if (getStringAsync(SELECTED_LANGUAGE_CODE) == data.languageCode.validate() && appStore.isDarkMode) {
      return primaryColor.withOpacity(0.2);
    } else if (getStringAsync(SELECTED_LANGUAGE_CODE) == data.languageCode.validate() && !appStore.isDarkMode) {
      return primaryColor.withOpacity(0.1);
    } else {
      return null;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblChangeLanguage,
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
            localeLanguageList.length,
            (index) {
              LanguageDataModel data = localeLanguageList[index];

              return Container(
                decoration: BoxDecoration(
                  borderRadius: radius(),
                  color: getSelectedColor(data),
                  border: Border.all(color: context.dividerColor),
                ),
                width: context.width() / 2 - 24,
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data.name.validate(), style: boldTextStyle()),
                        8.height,
                        Text(data.subTitle.validate(), style: secondaryTextStyle()),
                      ],
                    ).expand(),
                    Image.asset(data.flag.validate(), width: 34),
                  ],
                ),
              ).onTap(
                () async {
                  await setValue(SELECTED_LANGUAGE_CODE, data.languageCode);
                  selectedLanguageDataModel = data;
                  await appStore.setLanguage(data.languageCode!);
                  setState(() {});
                },
                borderRadius: radius(),
              );
            },
          ),
        ),
      ),
    );
  }
}
