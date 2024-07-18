import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import '../dialogs/acerca_de_dialog.dart';
import '../dialogs/change_credentials_dialog.dart';

class PerfilPage extends StatefulWidget {
  const PerfilPage({Key? key}) : super(key: key);

  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<PerfilPage> {
  final AuthController _authController = AuthController();
  String _fullName = '';

  @override
  void initState() {
    super.initState();
    _fetchUserFullName();
  }

  Future<void> _fetchUserFullName() async {
    String? fullName = await _authController.getUserFullName();
    if (fullName != null) {
      setState(() {
        _fullName = fullName;
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    context.go('/');
  }

  void _showAcercaDeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AcercaDeDialog();
      },
    );
  }

  void _showChangeEmailDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeCredentialsDialog(initialOption: 'email');
      },
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ChangeCredentialsDialog(initialOption: 'password');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('profile.title'.tr()),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/img/programador.png'),
              ),
              const SizedBox(height: 20),
              Text(
                _fullName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              _buildProfileOption(Icons.email, 'profile.changeEmail'.tr(), onTap: _showChangeEmailDialog),
              _buildProfileOption(Icons.lock, 'profile.changePassword'.tr(), onTap: _showChangePasswordDialog),
              //_buildProfileOption(Icons.share, 'profile.shareReporTrash'.tr()),
              _buildProfileOption(Icons.info, 'Acerca de ReporTrash', onTap: _showAcercaDeDialog),
              _buildProfileOption(Icons.logout, 'profile.signOff'.tr(), onTap: _signOut),
              SizedBox(height: 20),
              Text(
                'common.location'.tr(),
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String text, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: Colors.black),
            ),
            const SizedBox(width: 16),
            Text(
              text,
              style: TextStyle(fontSize: 18),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
