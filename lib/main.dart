import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:news_app/app/cubit/navigation/navigation_cubit.dart';
import 'package:news_app/bloc_observer.dart';

import 'config/app_router.dart' as router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = AppBlocObserver();
  // NewsService(categoryService: CategoryService()).addDataToFirebase();
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
      enabled: false,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(410, 730),
        builder: () => BlocProvider(
          create: (context) => NavigationCubit(),
          child: MaterialApp(
            title: 'Flutter Demo',
            onGenerateRoute: router.generateRoute,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
          ),
        ),
      ),
    );
  }
}
