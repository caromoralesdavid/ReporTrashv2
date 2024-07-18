import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../components/inicio_page.dart';
import '../components/my_reports_page.dart';
import '../components/perfil_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final NotchBottomBarController _controller;
  final PageController _pageController = PageController(initialPage: 0);
  bool _showAppBar = true;

  final List<String> _titles = [
    'ReporTrash',
    'Mis Reportes',
    'Profile',
  ];

  @override
  void initState() {
    super.initState();
    _controller = NotchBottomBarController(index: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showAppBar
          ? AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              context.go('/');
            },
          ),
        ],
      )
          : null,
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const InicioPage(),
          const MyReportsPage(),
          const PerfilPage(),
        ],
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedNotchBottomBar(
        notchBottomBarController: _controller,
        color: Colors.white,
        showLabel: false,
        notchColor: Colors.cyanAccent[100]!,
        bottomBarItems: [
          BottomBarItem(
            inActiveItem: const Icon(Icons.home, color: Colors.blueGrey),
            activeItem: const Icon(Icons.home, color: Colors.purpleAccent),
          ),
          BottomBarItem(
            inActiveItem: const Icon(Icons.history, color: Colors.blueGrey),
            activeItem: const Icon(Icons.history, color: Colors.deepPurpleAccent),
          ),
          BottomBarItem(
            inActiveItem: const Icon(Icons.settings, color: Colors.blueGrey),
            activeItem: const Icon(Icons.settings, color: Colors.pink),
          ),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            _controller.jumpTo(index);
            _pageController.jumpToPage(index);
            _showAppBar = index != 2; // Oculta el AppBar solo en la página de perfil (índice 2)
          });
        },
        kIconSize: 24,
        kBottomRadius: 20,
      ),
    );
  }
}
