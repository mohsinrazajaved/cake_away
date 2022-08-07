// @dart=2.9
import 'package:cake_away/Auth/splash.dart';
import 'package:cake_away/Home/terms.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

String selectedLanguage = 'English';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MobileAds.instance.initialize();
  runApp(
    EasyLocalization(
      path: 'assets/locales',
      supportedLocales: [Locale('en', 'US'), Locale('fr', 'CA')],
      child: App(true),
    ),
  );
  // runApp(MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   home: App(true),
  // ));
}

class App extends StatefulWidget {
  bool status;
  App(this.status);
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error"));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return Terms(); //Splash();
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
