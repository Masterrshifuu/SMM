import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:provider/provider.dart';
import 'package:smm/firebase_options.dart';
import 'package:smm/providers/auth_provider.dart';
import 'package:smm/providers/cart_provider.dart';
import 'package:smm/providers/order_provider.dart';
import 'package:smm/providers/product_provider.dart';
import 'package:smm/screens/main_nav_screen.dart';
import 'package:smm/screens/auth/login_screen.dart';
import 'package:smm/constants/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Sangma Megha Mart',
        theme: ThemeData(
          primaryColor: AppColors.primaryYellow,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'PTSans',
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryYellow,
            primary: AppColors.primaryYellow,
            secondary: AppColors.primaryYellow,
          ),
          useMaterial3: true,
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: Colors.black),
        ),
        home: StreamBuilder<firebase_auth.User?>(
          stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            
            final user = snapshot.data;
            if (user != null) {
              return const MainNavScreen();
            }
            
            return const LoginScreen();
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}