import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:futela/authentification/login_page.dart';
import 'package:futela/language/language_preferences.dart';
import 'package:futela/widgets/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure plugin services are initialized

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? savedLanguage = prefs.getString('language');

  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'en_US',
    supportedLocales: [
      'en_US',
      'fr',
    ],
    preferences: TranslatePreferences(savedLanguage),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Themeprovider()),
        // ChangeNotifierProvider(create: (_) => /StockNotifier()),
      ],
      child: LocalizedApp(
        delegate,
        const MyApp(),
      ),
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

    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: localizationDelegate.supportedLocales,
        locale: localizationDelegate.currentLocale,
        theme: Provider.of<Themeprovider>(context).themeData,
        debugShowCheckedModeBanner: false,
        initialRoute: '/signup',
        routes: {
          '/signup':(context)=> const LoginPage(),

        },
      ),
    );
  }
}
