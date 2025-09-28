import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController()); // AuthController globally available
  runApp(const HelpMeSpeakApp());
}

class HelpMeSpeakApp extends StatelessWidget {
  const HelpMeSpeakApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: "HelpMeSpeak",
      routerDelegate: AppPages.router.routerDelegate,
      routeInformationParser: AppPages.router.routeInformationParser,
      routeInformationProvider: AppPages.router.routeInformationProvider,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: Colors.white,
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:device_preview/device_preview.dart';
// import 'controllers/auth_controller.dart';
// import 'app/routes/app_pages.dart';
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   Get.put(AuthController());
//
//   runApp(
//     DevicePreview(
//       enabled: true,
//       builder: (context) => const HelpMeSpeakApp(),
//     ),
//   );
// }
//
// class HelpMeSpeakApp extends StatelessWidget {
//   const HelpMeSpeakApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: "HelpMeSpeak",
//       locale: DevicePreview.locale(context),
//       builder: DevicePreview.appBuilder,
//
//       routerDelegate: AppPages.router.routerDelegate,
//       routeInformationParser: AppPages.router.routeInformationParser,
//       routeInformationProvider: AppPages.router.routeInformationProvider,
//       theme: ThemeData(
//         primarySwatch: Colors.indigo,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//     );
//   }
// }
