import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fusion_healthcare/core/key_constant.dart';
import 'package:fusion_healthcare/pages/appointment_checkin_page.dart';
import 'package:fusion_healthcare/pages/find_patient_page.dart';
import 'package:fusion_healthcare/pages/welcome_page.dart' show WelcomePage;
import 'package:fusion_healthcare/providers/appointment_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppointmentProvider())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: KeyConstant.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      // Register the essential localization delegates
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Define the regions your application accepts
      supportedLocales: [
        Locale('en', 'US'), // Enforces MM/DD/YYYY
        Locale('en', 'GB'), // Enforces DD/MM/YYYY
        Locale('fr', 'FR'), // Enforces DD/MM/YYYY
      ],
      initialRoute: '/',
      routes: {
        // '/': (context) => DiagnosticCenterLandingPage(),
        '/': (context) => WelcomePage(),
        '/new-patient': (context) => const AppointmentCheckInPage(),
        '/old-patient': (context) => const FindPatientPage(),
      },
    );
  }
}
