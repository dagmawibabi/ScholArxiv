import "package:arxiv/pages/homePage.dart";
import "package:flutter/material.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {"/": (context) => HomePage()},
      themeMode: ThemeMode.light,
      theme: ThemeData(
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          actionsIconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
