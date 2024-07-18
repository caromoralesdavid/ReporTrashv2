import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<User?> registerUser(String fullName, String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
        });
        Logger.log('Usuario registrado exitosamente: ${user.uid}');
      }
      return user;
    } catch (e, stackTrace) {
      Logger.logError('Error durante el registro', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<User?> loginUser(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      Logger.log('Inicio de sesión exitoso: ${user?.uid}');
      return user;
    } catch (e, stackTrace) {
      Logger.logError('Error durante el inicio de sesión', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<String?> getUserFullName(String userId) async {
    try {
      DocumentSnapshot userSnapshot = await firestore.collection('users').doc(userId).get();
      if (userSnapshot.exists) {
        return userSnapshot.get('fullName');
      }
      return null;
    } catch (e, stackTrace) {
      Logger.logError('Error fetching user full name', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> changeEmail(String currentEmail, String currentPassword, String newEmail) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: currentEmail, password: currentPassword);
        await user.reauthenticateWithCredential(credential);

        if (newEmail.endsWith('@gmail.com')) {
          // Configurar el idioma del correo de verificación a español
          await _auth.setLanguageCode('es');
          await user.verifyBeforeUpdateEmail(newEmail);
          Logger.log('Correo de verificación en español enviado a la nueva dirección de Gmail');
        } else {
          throw Exception('Solo se permiten correos electrónicos de Gmail');
        }
      }
    } catch (e, stackTrace) {
      Logger.logError('Error al cambiar el correo electrónico', error: e, stackTrace: stackTrace);
      throw e;
    }
  }

  Future<void> changePassword(String email, String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        AuthCredential credential = EmailAuthProvider.credential(email: email, password: currentPassword);
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);
        Logger.log('Contraseña actualizada exitosamente');
      }
    } catch (e, stackTrace) {
      Logger.logError('Error al cambiar la contraseña', error: e, stackTrace: stackTrace);
      throw e;
    }
  }
}
