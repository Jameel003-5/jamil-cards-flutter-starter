import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config.dart';
import '../../controllers/nfc_tag_controller.dart';
import 'dashboard_layout.dart';

class DashboardOverviewScreen extends StatelessWidget {
  final NFCTagController tagController = Get.find<NFCTagController>();

  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'Dashboard Overview',
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
            SizedBox(height: 24),
            _buildStatsGrid(),
            SizedBox(height: 24),
            _buildQuickActions(),
            SizedBox(height: 24),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    return Obx(() {
      final totalTags = tagController.tags.length;
      final activeTags = tagController.tags.where((tag) => tag.isActivated).length;
      final inactiveTags = totalTags - activeTags;

      return GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildStatCard(
            'Total Tags',
            totalTags.toString(),
            Icons.nfc,
            Colors.blue,
          ),
          _buildStatCard(
            'Active Tags',
            activeTags.toString(),
            Icons.check_circle,
            Colors.green,
          ),
          _buildStatCard(
            'Inactive Tags',
            inactiveTags.toString(),
            Icons.cancel,
            Colors.orange,
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: UiConfig.fontPrime,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: UiConfig.fontPrime,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Add New Tag',
                Icons.add_circle,
                Colors.green,
                () => Get.toNamed('/dashboard/tags'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Manage Users',
                Icons.people,
                Colors.blue,
                () => Get.toNamed('/dashboard/users'),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                'Settings',
                Icons.settings,
                Colors.purple,
                () => Get.toNamed('/dashboard/settings'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: onPressed,
      child: Column(
        children: [
          Icon(icon, size: 24),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: UiConfig.fontPrime,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: UiConfig.fontPrime,
          ),
        ),
        SizedBox(height: 16),
        Card(
          child: Obx(() {
            final recentTags = tagController.tags.take(5).toList();
            
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: recentTags.length,
              itemBuilder: (context, index) {
                final tag = recentTags[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: tag.isActivated ? Colors.green : Colors.grey,
                    child: Icon(Icons.nfc, color: Colors.white),
                  ),
                  title: Text(
                    'Tag ID: ${tag.uid}',
                    style: TextStyle(
                      fontFamily: UiConfig.fontPrime,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    tag.isActivated
                        ? 'Activated on ${tag.activatedAt?.toLocal().toString().split('.')[0]}'
                        : 'Not activated',
                    style: TextStyle(fontFamily: UiConfig.fontPrime),
                  ),
                  trailing: Icon(
                    tag.isActivated
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: tag.isActivated ? Colors.green : Colors.grey,
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
