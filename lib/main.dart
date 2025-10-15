import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spendwise/constants/string_constants.dart';
import 'package:spendwise/dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:spendwise/features/authentication/presentation/login_screen.dart';
import 'package:spendwise/navigation/routes.dart';
import 'package:spendwise/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase with platform-specific options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up dependency injection for the app
  await Dependencies().setUpDependencyInjection();

  runApp(
    ProviderScope(
      child: MaterialApp(
        title: StringConstants.appTitle,
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: Routes.splashScreen,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: SpendWiseTheme.lightColorScheme,
        ),
      ),
    ),
  );
}
