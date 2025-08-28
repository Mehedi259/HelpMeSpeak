// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:device_preview/device_preview.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const HelpMeSpeakApp(),
    ),
  );
}

class HelpMeSpeakApp extends StatelessWidget {
  const HelpMeSpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          title: 'HelpMeSpeak',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerDelegate: AppPages.router.routerDelegate,
          routeInformationParser: AppPages.router.routeInformationParser,
          routeInformationProvider: AppPages.router.routeInformationProvider,
          // device preview এর config
          locale: DevicePreview.locale(context),
          builder: DevicePreview.appBuilder,
        );
      },
    );
  }
}
