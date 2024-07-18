import 'package:go_router/go_router.dart';
import '../views/LoginScreen.dart';
import '../views/RegisterScreen.dart';
import '../views/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => LoginScreen(),
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          return '/home';
        }
        return null;
      },
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => HomeScreen(),
    ),
  ],
);
