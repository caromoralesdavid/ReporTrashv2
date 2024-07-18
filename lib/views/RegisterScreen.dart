import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';
import '../widgets/input_text_field.dart';
import '../widgets/custom_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  String _fullName = '';
  String _email = '';
  String _password = '';
  String _confirmPassword = '';
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_password == _confirmPassword) {
        await _authController.registerUser(context, _fullName, _email, _password);
      } else {
        CustomSnackbar.show(
          context,
          'auth.register.passwordsDoNotMatch'.tr(),
          SnackbarState.error,
        );
      }
    }
  }

  void _togglePasswordVisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _showConfirmPassword = !_showConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomLogo(),
                  SizedBox(height: 40),
                  InputTextField(
                    labelText: 'auth.register.fullName'.tr(),
                    hintText: 'auth.register.enterFullName'.tr(),
                    icon: Icons.person,
                    textCapitalization: TextCapitalization.words,
                    onChanged: (value) {
                      setState(() {
                        _fullName = value;
                      });
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'auth.register.pleaseEnterFullName'.tr();
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  InputTextField(
                    labelText: 'common.email'.tr(),
                    hintText: 'common.enterEmail'.tr(),
                    icon: Icons.email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'common.pleaseEnterEmail'.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _email = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  InputTextField(
                    labelText: 'common.password'.tr(),
                    hintText: 'common.enterPassword'.tr(),
                    icon: Icons.lock,
                    obscureText: true,
                    showPassword: _showPassword,
                    onTogglePasswordVisibility: _togglePasswordVisibility,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'common.pleaseEnterPassword'.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _password = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  InputTextField(
                    labelText: 'auth.register.confirmPassword'.tr(),
                    hintText: 'auth.register.confirmYourPassword'.tr(),
                    icon: Icons.lock,
                    obscureText: true,
                    showPassword: _showConfirmPassword,
                    onTogglePasswordVisibility: _toggleConfirmPasswordVisibility,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'auth.register.pleaseConfirmPassword'.tr();
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _confirmPassword = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  CustomButton(
                    text: 'auth.register.title'.tr(),
                    onPressed: _submitForm,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.go('/');
                    },
                    child: Text(
                      'auth.register.alreadyHaveAccount'.tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    'common.location'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
