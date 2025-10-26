import 'package:gebeya/pages/Seettings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:gebeya/pages/SignIn_page.dart';
import 'package:gebeya/pages/SignUp_page.dart';
import 'package:gebeya/pages/Main_Page.dart';
import 'package:provider/provider.dart';
import 'package:gebeya/providers/product-provider.dart';
import 'package:gebeya/providers/cart-provider.dart';
import 'package:gebeya/providers/auth_provider.dart';
import 'package:gebeya/providers/orders_provider.dart';
import 'package:gebeya/providers/address_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    print('Firebase initialization error: $e');
    // Continue without Firebase for now
  }
  
  runApp( 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
      ],
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/signup',
      routes: {
        '/Settings_Page': (context) => const SettingsPage(),
        '/Main_Page': (context) => const MainPage(),
        '/signin': (context) => const SigninPage(),
        '/signup': (context) => const SignupPage(),
      },
      debugShowCheckedModeBanner: false,
      home: const SignupPage(),
    );
  }
}