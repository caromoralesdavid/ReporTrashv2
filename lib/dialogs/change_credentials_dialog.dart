import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/input_text_field.dart';
import '../controllers/auth_controller.dart';

class ChangeCredentialsDialog extends StatefulWidget {
  final String initialOption;

  ChangeCredentialsDialog({required this.initialOption});

  @override
  _ChangeCredentialsDialogState createState() => _ChangeCredentialsDialogState();
}

class _ChangeCredentialsDialogState extends State<ChangeCredentialsDialog> {
  final AuthController _authController = AuthController();

  String _currentEmail = '';
  String _currentPassword = '';
  String _newEmail = '';
  String _newPassword = '';

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          widget.initialOption == 'email' ? 'change_credentials.change_email'.tr() : 'change_credentials.change_password'.tr(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            InputTextField(
              labelText: 'change_credentials.current_email'.tr(),
              hintText: 'change_credentials.enter_current_email'.tr(),
              icon: Icons.email,
              onChanged: (value) {
                _currentEmail = value;
              },
            ),
            SizedBox(height: 16),
            InputTextField(
              labelText: 'change_credentials.current_password'.tr(),
              hintText: 'change_credentials.enter_current_password'.tr(),
              icon: Icons.lock,
              obscureText: true,
              showPassword: _showCurrentPassword,
              onChanged: (value) {
                _currentPassword = value;
              },
              onTogglePasswordVisibility: () {
                setState(() {
                  _showCurrentPassword = !_showCurrentPassword;
                });
              },
            ),
            SizedBox(height: 16),
            if (widget.initialOption == 'email')
              InputTextField(
                labelText: 'change_credentials.new_email'.tr(),
                hintText: 'change_credentials.enter_new_email'.tr(),
                icon: Icons.email,
                onChanged: (value) {
                  _newEmail = value;
                },
              ),
            if (widget.initialOption == 'password')
              InputTextField(
                labelText: 'change_credentials.new_password'.tr(),
                hintText: 'change_credentials.enter_new_password'.tr(),
                icon: Icons.lock,
                obscureText: true,
                showPassword: _showNewPassword,
                onChanged: (value) {
                  _newPassword = value;
                },
                onTogglePasswordVisibility: () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                },
              ),
          ],
        ),
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'change_credentials.cancel'.tr(),
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 16),
            TextButton(
              onPressed: () async {
                if (widget.initialOption == 'email') {
                  await _authController.changeEmail(context, _currentEmail, _currentPassword, _newEmail);
                } else if (widget.initialOption == 'password') {
                  await _authController.changePassword(context, _currentEmail, _currentPassword, _newPassword);
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'change_credentials.save'.tr(),
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
