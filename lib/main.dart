import 'package:device_preview/device_preview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/base_screen.dart';
import 'package:news_app/config/app_router.dart' as router;
import 'package:news_app/features/auth/screens/auth_test.dart';
import 'package:news_app/features/auth/screens/sign_up_screen.dart';
import 'package:news_app/features/news_feed/services/news_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  NewsService().getAllNews();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return DevicePreview(
      enabled: true,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(410, 730),
        builder: () => MaterialApp(
          title: 'Flutter Demo',
          initialRoute: BaseScreen.route,
          onGenerateRoute: router.generateRoute,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
        ),
      ),
    );
  }
}
