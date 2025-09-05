// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const HelpMeSpeakApp());
}

class HelpMeSpeakApp extends StatelessWidget {
  const HelpMeSpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp.router(
          title: 'HelpMeSpeak',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerDelegate: AppPages.router.routerDelegate,
          routeInformationParser: AppPages.router.routeInformationParser,
          routeInformationProvider: AppPages.router.routeInformationProvider,
        );
      },
    );
  }
}
