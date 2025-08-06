import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';
import 'services/snack_service.dart';
import 'services/admin_service.dart';
import 'pages/auth_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/admin_dashboard_page.dart';
import 'utils/colors.dart';
import 'utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SnackService()),
        ChangeNotifierProvider(create: (_) => AdminService()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        theme: ThemeData(
          primaryColor: AppColors.accent,
          fontFamily: 'Inter',
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.accent),
        ),
        home: AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthService>(
      builder: (context, authService, child) {
        if (authService.isLoading) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authService.isLoggedIn) {
          return AuthPage();
        }

        // Check if user is admin
        if (authService.user != null) {
          // For now, Sandy's email makes her admin
          // Later, this will be stored in the user model
          if (authService.user!.email == 'sandy@example.com' ||
              authService.user!.email == 'hms10dev@gmail.com') {
            return AdminDashboardPage();
          }
        }

        return DashboardPage();
      },
    );
  }
}
