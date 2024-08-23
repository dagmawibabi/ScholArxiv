import "package:arxiv/models/bookmarks.dart";
import "package:arxiv/pages/homePage.dart";
import "package:flutter/material.dart";
import "package:hive_flutter/hive_flutter.dart";
import 'package:theme_provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BookmarkAdapter());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}
//simple comment to test workflow
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
            routes: {"/": (context) => const HomePage()},
          ),
        ),
      ),
    );
  }
}
