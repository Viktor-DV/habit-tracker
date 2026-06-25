import 'package:flutter/material.dart';
import 'package:habit_tracker/app/app_router.dart';
import 'package:habit_tracker/app/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Трекер привычек',
      theme: appThemeData(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
