import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config.dart';

class DashboardLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget>? actions;

  const DashboardLayout({
    Key? key,
    required this.title,
    required this.child,
    this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: UiConfig.colorSec,
        title: Text(
          title,
          style: TextStyle(
            fontFamily: UiConfig.fontPrime,
            color: Colors.white,
          ),
        ),
        actions: actions,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: UiConfig.colorSec,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: UiConfig.colorSec,
                      size: 30,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: UiConfig.fontPrime,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(
                'Overview',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
              onTap: () => Get.toNamed('/dashboard'),
            ),
            ListTile(
              leading: Icon(Icons.nfc),
              title: Text(
                'NFC Tags',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
              onTap: () => Get.toNamed('/dashboard/tags'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(
                'Users',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
              onTap: () => Get.toNamed('/dashboard/users'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(
                'Settings',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
              onTap: () => Get.toNamed('/dashboard/settings'),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Logout',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
              onTap: () {
                // TODO: Implement logout
                Get.offAllNamed('/');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
