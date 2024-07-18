import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import '../widgets/input_text_field.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_logo.dart';
import '../widgets/custom_snackbar.dart';
import 'package:easy_localization/easy_localization.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthController _authController = AuthController();
  String _email = '';
  String _password = '';
  bool _showPassword = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final result = await _authController.loginUser(context, _email, _password);
      if (result == null) {
        CustomSnackbar.show(
          context,
          'auth.login.errorLogin'.tr(),
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
                children: <Widget>[
                  CustomLogo(),
                  SizedBox(height: 40),
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
                  CustomButton(
                    text: 'auth.login.title'.tr(),
                    onPressed: _submitForm,
                  ),
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      context.go('/register');
                    },
                    child: Text(
                      "auth.login.noAccount".tr(),
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
