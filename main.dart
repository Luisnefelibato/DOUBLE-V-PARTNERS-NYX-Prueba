
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_provider.dart';
import 'theme/cyberpunk_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_form_screen.dart';
import 'screens/address_management_screen.dart';
import 'screens/user_profile_screen.dart';

void main() {
  runApp(const DoubleVPartnersNyxApp());
}

class DoubleVPartnersNyxApp extends StatelessWidget {
  const DoubleVPartnersNyxApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(create: (_) => ValidationProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: 'Double V Partners NYX - User Management',
            debugShowCheckedModeBanner: false,
            theme: CyberpunkTheme.darkTheme,
            initialRoute: '/',
            onGenerateRoute: _generateRoute,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0, // Prevent text scaling
                ),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  static Route<dynamic>? _generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _createRoute(const SplashScreen());

      case '/home':
        return _createRoute(const HomeScreen());

      case '/user-list':
        return _createRoute(const UserListScreen());

      case '/user-form':
        return _createRoute(const UserFormScreen());

      case '/address-management':
        return _createRoute(const AddressManagementScreen());

      case '/profile':
        return _createRoute(const UserProfileScreen());

      default:
        return _createRoute(
          Scaffold(
            backgroundColor: CyberpunkColors.background,
            body: Container(
              decoration: BoxDecoration(
                gradient: CyberpunkColors.backgroundGradient,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: CyberpunkColors.error,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Página no encontrada',
                      style: TextStyle(
                        color: CyberpunkColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'La ruta "${settings.name}" no existe',
                      style: TextStyle(
                        color: CyberpunkColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
    }
  }

  static PageRouteBuilder _createRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
