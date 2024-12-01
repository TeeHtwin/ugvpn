import 'package:flutter/material.dart';
import 'package:internet_speed_test/callbacks_enum.dart';
import 'package:internet_speed_test/internet_speed_test.dart';
import 'package:mightyvpn/component/internet_component.dart';
import 'package:mightyvpn/main.dart';
import 'package:mightyvpn/utils/colors.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class InternetSpeedTestScreen extends StatefulWidget {
  const InternetSpeedTestScreen({Key? key}) : super(key: key);

  @override
  _InternetSpeedTestScreenState createState() => _InternetSpeedTestScreenState();
}

class _InternetSpeedTestScreenState extends State<InternetSpeedTestScreen> {
  InternetSpeedTest internetSpeedTest = InternetSpeedTest();
  double downloadRate = 0;
  double uploadRate = 0;
  double downloadProgress = 0.0;
  double uploadProgress = 0.0;
  double displayRate = 0;
  String displayRateTxt = '0.0';
  double displayPer = 0;
  String unitText = 'Mb/s';

  bool isTesting = false;

  String value = "";

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void startDownloading() {
    internetSpeedTest.startDownloadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        setState(() {
          downloadRate = transferRate;
          protectGauge(downloadRate);
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          downloadProgress = 100.0;
          displayPer = 100.0;
        });
        startUploading();
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        value = "Downloading Speed";
        setState(() {
          downloadRate = transferRate;
          protectGauge(downloadRate);
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          downloadProgress = percent;
          displayPer = percent;
        });
      },
      onError: (String errorMessage, String speedTestError) {
        toast(language.lblDownloadTestFailed);
        setState(() {
          value = language.lblStartTest;
          isTesting = false;
        });
      },
      fileSize: 1,
    );
  }

  void startUploading() {
    internetSpeedTest.startUploadTesting(
      onDone: (double transferRate, SpeedUnit unit) {
        setState(() {
          uploadRate = transferRate;
          uploadRate = uploadRate * 10;
          protectGauge(uploadRate);
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          uploadProgress = 100.0;
          displayPer = 100.0;
          isTesting = false;
          value = "";
        });
      },
      onProgress: (double percent, double transferRate, SpeedUnit unit) {
        value = "Uploading Speed";

        setState(() {
          uploadRate = transferRate;
          uploadRate = uploadRate * 10;
          protectGauge(uploadRate);
          unitText = unit == SpeedUnit.Kbps ? 'Kb/s' : 'Mb/s';
          uploadProgress = percent;
          displayPer = percent;
        });
      },
      onError: (String errorMessage, String speedTestError) {
        toast(language.lblUploadTestFailed);
        setState(() {
          isTesting = false;
        });
      },
      fileSize: 1,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void protectGauge(double rate) {
    if (rate > 100) {
      displayRateTxt = rate.toStringAsFixed(2);
    } else {
      displayRate = rate;
      displayRateTxt = displayRate.toStringAsFixed(2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        language.lblInternetSpeedTest,
        showBack: false,
        center: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16),
          width: context.width(),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SfRadialGauge(
                title: const GaugeTitle(text: ' ', textStyle: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: 100,
                    axisLabelStyle: const GaugeTextStyle(color: primaryColor),
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: 30, color: primaryColor.withOpacity(0.7), startWidth: 10, endWidth: 10),
                      GaugeRange(startValue: 30, endValue: 60, color: primaryColor.withOpacity(0.7), startWidth: 10, endWidth: 10),
                      GaugeRange(startValue: 60, endValue: 100, color: primaryColor.withOpacity(0.7), startWidth: 10, endWidth: 10)
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: displayRate, enableAnimation: true, needleColor: primaryColor, animationType: AnimationType.bounceOut),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: createRichText(
                          list: [
                            TextSpan(text: displayRate.toStringAsFixed(2), style: boldTextStyle(size: 24, color: primaryColor)),
                            TextSpan(text: " $unitText", style: secondaryTextStyle(size: 14)),
                          ],
                        ),
                        angle: 90,
                        positionFactor: 0.6,
                      ),
                    ],
                  )
                ],
              ),
              AppButton(
                color: appButtonColor,
                elevation: 0,
                textColor: primaryColor,
                enabled: value.isEmpty,
                text: value.isEmpty ? language.lblStartTest : value,
                onTap: () {
                  if (!isTesting) {
                    isTesting = true;
                    downloadRate = 0;
                    uploadRate = 0;
                    setState(() {});
                    startDownloading();
                  }
                },
              ),
              32.height,
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  InternetComponent(rate: downloadRate, iconData: Icons.arrow_downward_outlined).expand(),
                  InternetComponent(rate: uploadRate, iconData: Icons.arrow_upward_outlined).expand(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
