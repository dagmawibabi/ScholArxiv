import "package:another_flutter_splash_screen/another_flutter_splash_screen.dart";
import "package:arxiv/models/bookmarks.dart";
import "package:arxiv/models/paper.dart";
import "package:arxiv/pages/home_page.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import 'package:theme_provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  Hive.registerAdapter(PaperAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      themes: [
        AppTheme(
          id: "light_theme",
          description: "light_theme",
          data: ThemeData(
            primaryColor: Colors.white,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.black,
              foregroundColor: Colors.black,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.black,
              ),
              bodyMedium: TextStyle(
                color: Colors.black,
              ),
              bodySmall: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.black,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
        ),
        AppTheme(
          id: "dark_theme",
          description: "dark_theme",
          data: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              surfaceTintColor: Colors.black,
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.white,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
        ),
        AppTheme(
          id: "mixed_theme",
          data: ThemeData(
            primaryColor: Colors.black,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xff121212),
              surfaceTintColor: Color(0xff121212),
              foregroundColor: Colors.white,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(
                color: Colors.black,
              ),
              bodyMedium: TextStyle(
                color: Colors.black,
              ),
              bodySmall: TextStyle(
                color: Colors.black,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          description: "mixed_theme",
        ),
      ],
      child: ThemeConsumer(
        child: Builder(
          builder: (themeContext) => MaterialApp(
            theme: ThemeProvider.themeOf(themeContext).data,
            debugShowCheckedModeBanner: false,
            initialRoute: "/",
            routes: {
              "/": (context) => FlutterSplashScreen.fadeIn(
                    backgroundColor: Colors.white,
                    onInit: () {
                      debugPrint("On Init");
                    },
                    onEnd: () {
                      debugPrint("On End");
                    },
                    childWidget: Container(
                      color: ThemeProvider.themeOf(themeContext)
                          .data
                          .scaffoldBackgroundColor,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child:
                          Image.asset("assets/icon/icon-removebg-preview.png"),
                    ),
                    onAnimationEnd: () => debugPrint("On Fade In End"),
                    nextScreen: const HomePage(),
                  )
            },
          ),
        ),
      ),
    );
  }
}
