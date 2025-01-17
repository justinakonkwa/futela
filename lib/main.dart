import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/authentification/signup_page.dart';
import 'package:futela/authentification/verification.dart';
import 'package:futela/language/language_preferences.dart';
import 'package:futela/main_page.dart';
import 'package:futela/modeles/user_provider.dart';
import 'package:futela/pages/intro_screens/Intro.dart';
import 'package:futela/pages/menu/chatpage.dart';
import 'package:futela/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialiser les services requis

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLanguage = prefs.getString('language');

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: ['en_US', 'fr'],
    preferences: TranslatePreferences(savedLanguage),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initializeTheme()),
      ],
      child: LocalizedApp(delegate, const MyApp()),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            DefaultCupertinoLocalizations.delegate,
            localizationDelegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: themeProvider.themeData,
          initialRoute: '/authentication', // Définir la route initiale
          routes: {
            '/authentication': (context) => AuthVerification(),
            '/login': (context) => LoginPage(),
            '/signup': (context) => SignUpPage(),
            '/main': (context) => MainPage(),
            '/chat': (context) => ChatPage(),

          },
        );
      },
    );
  }
}
