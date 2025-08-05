import 'package:dreemz/core/logg.dart';
import 'package:dreemz/core/routes.dart';
import 'package:dreemz/core/themes/theme_controller.dart';
import 'package:dreemz/service/storage_service.dart';
import 'package:dreemz/views/unknown_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {

  await initServices();

  runApp(const MyApp());
}

initServices() async {
  Get.put(StorageService());
  StorageService storageService = Get.find();
  await storageService.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: ThemeController(),
      builder: (controller) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: controller.getThemeData(),
          initialRoute: Routes.homePage,
          unknownRoute: Routes.unknownWidget,
          enableLog: kDebugMode,
          getPages: Routes.routePage,
          defaultTransition: Transition.fadeIn,
          logWriterCallback: (text, {isError = false}) {
            Logg.printLog("GetXLog : $text");
          },
          builder: (BuildContext context, Widget? widget) {
            ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
              return UnknownPage(
                error: errorDetails.toString(),
              );
            };
            final MediaQueryData mediaQueryData = MediaQuery.of(context);
            return MediaQuery(
              data: mediaQueryData.copyWith(
                platformBrightness: Brightness.light,
                alwaysUse24HourFormat: true,
              ),
              child: widget ?? UnknownPage(),
            );
          },
        );
      },
    );
  }
}
