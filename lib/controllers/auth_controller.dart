import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';
import '../widgets/custom_snackbar.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<User?> registerUser(BuildContext context, String fullName, String email, String password) async {
    try {
      User? user = await _authService.registerUser(fullName, email, password);
      if (user != null) {
        Logger.log('Registro exitoso. Usuario: ${user.uid}');
        context.go('/home');
      } else {
        Logger.log('Error durante el registro');
      }
      return user;
    } catch (e, stackTrace) {
      Logger.logError('Error durante el registro', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<User?> loginUser(BuildContext context, String email, String password) async {
    try {
      User? user = await _authService.loginUser(email, password);
      if (user != null) {
        Logger.log('Inicio de sesión exitoso. Usuario: ${user.uid}');
        context.go('/home');
      } else {
        Logger.log('Error durante el inicio de sesión');
      }
      return user;
    } catch (e, stackTrace) {
      Logger.logError('Error durante el inicio de sesión', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<String?> getUserFullName() async {
    User? user = _authService.getCurrentUser();
    if (user != null) {
      return await _authService.getUserFullName(user.uid);
    }
    return null;
  }

  User? getCurrentUser() {
    return _authService.getCurrentUser();
  }

  Future<void> changeEmail(BuildContext context, String currentEmail, String currentPassword, String newEmail) async {
    try {
      await _authService.changeEmail(currentEmail, currentPassword, newEmail);
      Logger.log('Correo electrónico actualizado exitosamente');
      CustomSnackbar.show(context, 'Revisa tu Email para confirmar', SnackbarState.completed);
    } catch (e, stackTrace) {
      Logger.logError('Error al cambiar el correo electrónico', error: e, stackTrace: stackTrace);
      CustomSnackbar.show(context, 'Error al cambiar Email', SnackbarState.error);
    }
  }

  Future<void> changePassword(BuildContext context, String email, String currentPassword, String newPassword) async {
    try {
      await _authService.changePassword(email, currentPassword, newPassword);
      Logger.log('Contraseña actualizada exitosamente');
      CustomSnackbar.show(context, 'Contraseña actualizada', SnackbarState.completed);
    } catch (e, stackTrace) {
      Logger.logError('Error al cambiar la contraseña', error: e, stackTrace: stackTrace);
      CustomSnackbar.show(context, 'Error al cambiar contraseña', SnackbarState.error);
    }
  }

  AuthController() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        final userDoc = await _authService.firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists && userDoc.get('email') != user.email) {
          await userDoc.reference.update({'email': user.email});
          Logger.log('Correo electrónico del usuario actualizado en Firestore');
        }
      }
    });
  }
}
