import 'package:flutter/material.dart';

import '../common/styles.dart';
import '../utils/notification_helper.dart';

import 'restaurant_detail_page.dart';
import 'restaurant_favorites_page.dart';
import 'restaurant_list_page.dart';
import 'setting_page.dart';
import 'profile.dart';
import 'upload_toko.dart';
import 'upload_menu.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottonNavIndex = 0;

  final NotificationHelper _notificationHelper = NotificationHelper();

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant),
      label: 'Restoran',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.favorite),
      label: 'Favorit',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Pengaturan',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profil',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.store),
      label: 'Upload Toko',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.restaurant_menu),
      label: 'Upload Menu',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.logout),
      label: 'Logout',
    ),
  ];

  final List<Widget> _listWidget = [
    const RestaurantListPage(),
    const RestaurantFavoritesPage(),
    const SettingPage(),
    const ProfilePage(),
    const UploadTokoPage(),
    const UploadMenuPage(),
    const SizedBox.shrink(), // Logout tidak punya tampilan
  ];

  void _onBottomNavTapped(int index) async {
    // Index logout sekarang = 6
    if (index == 6) {
      bool? shouldLogout = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Konfirmasi Logout"),
          content: const Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Logout"),
            ),
          ],
        ),
      );

      if (shouldLogout == true) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      setState(() {
        _bottonNavIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _notificationHelper
        .configureSelectNotificationSubject(RestaurantDetailPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottonNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottonNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}
