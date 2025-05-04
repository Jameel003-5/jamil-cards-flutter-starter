import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../config.dart';
import '../../controllers/nfc_tag_controller.dart';
import '../../models/nfc_tag.dart';
import '../../widgets/loading_overlay.dart';
import 'dashboard_layout.dart';

class NFCTagsScreen extends GetView<NFCTagController> {
  @override
  Widget build(BuildContext context) {
    return DashboardLayout(
      title: 'NFC Tags Management',
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _showAddTagDialog(context),
        ),
      ],
      child: Obx(() => LoadingOverlay(
        isLoading: controller.isLoading.value,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Manage NFC Tags',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Card(
                child: controller.tags.isEmpty
                    ? Center(
                        child: Text(
                          'No NFC tags found',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontFamily: UiConfig.fontPrime,
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.tags.length,
                        itemBuilder: (context, index) {
                          final tag = controller.tags[index];
                          return _buildTagCard(context, tag);
                        },
                      ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildTagCard(BuildContext context, NFCTag tag) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: tag.isActivated ? Colors.green : Colors.grey,
          child: Icon(
            Icons.nfc,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Tag ID: ${tag.uid}',
          style: TextStyle(
            fontFamily: UiConfig.fontPrime,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status: ${tag.isActivated ? 'Activated' : 'Not Activated'}',
              style: TextStyle(
                color: tag.isActivated ? Colors.green : Colors.grey,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
            if (tag.assignedUserId != null)
              Text(
                'Assigned to: ${tag.assignedUserId}',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
            if (tag.activatedAt != null)
              Text(
                'Activated: ${tag.activatedAt!.toLocal().toString().split('.')[0]}',
                style: TextStyle(fontFamily: UiConfig.fontPrime),
              ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            if (!tag.isActivated)
              PopupMenuItem(
                value: 'activate',
                child: ListTile(
                  leading: Icon(Icons.check_circle, color: Colors.green),
                  title: Text(
                    'Activate',
                    style: TextStyle(fontFamily: UiConfig.fontPrime),
                  ),
                ),
              ),
            if (tag.isActivated)
              PopupMenuItem(
                value: 'deactivate',
                child: ListTile(
                  leading: Icon(Icons.cancel, color: Colors.orange),
                  title: Text(
                    'Deactivate',
                    style: TextStyle(fontFamily: UiConfig.fontPrime),
                  ),
                ),
              ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text(
                  'Delete',
                  style: TextStyle(fontFamily: UiConfig.fontPrime),
                ),
              ),
            ),
          ],
          onSelected: (value) async {
            switch (value) {
              case 'activate':
                _showActivateTagDialog(context, tag);
                break;
              case 'deactivate':
                _showDeactivateConfirmation(context, tag);
                break;
              case 'delete':
                _showDeleteConfirmation(context, tag);
                break;
            }
          },
        ),
      ),
    );
  }

  void _showAddTagDialog(BuildContext context) {
    final TextEditingController uidController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text(
          'Add New NFC Tag',
          style: TextStyle(fontFamily: UiConfig.fontPrime),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: uidController,
              decoration: InputDecoration(
                labelText: 'Tag UID',
                hintText: 'Enter the NFC tag UID',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (uidController.text.isNotEmpty) {
                controller.addTag(uidController.text);
                Get.back();
              }
            },
            child: Text(
              'Add',
              style: TextStyle(fontFamily: UiConfig.fontPrime),
            ),
          ),
        ],
      ),
    );
  }

  void _showActivateTagDialog(BuildContext context, NFCTag tag) {
    final TextEditingController userIdController = TextEditingController();
    
    Get.dialog(
      AlertDialog(
        title: Text(
          'Activate NFC Tag',
          style: TextStyle(fontFamily: UiConfig.fontPrime),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(
                labelText: 'User ID',
                hintText: 'Enter the user ID to assign',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (userIdController.text.isNotEmpty) {
                controller.activateTag(tag.id, userIdController.text);
                Get.back();
              }
            },
            child: Text(
              'Activate',
              style: TextStyle(fontFamily: UiConfig.fontPrime),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeactivateConfirmation(BuildContext context, NFCTag tag) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Deactivate Tag',
          style: TextStyle(fontFamily: UiConfig.fontPrime),
        ),
        content: Text(
          'Are you sure you want to deactivate this tag?',
          style: TextStyle(fontFamily: UiConfig.fontPrime),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            onPressed: () {
              controller.deactivateTag(tag.id);
              Get.back();
            },
            child: Text(
              'Deactivate',
              style: TextStyle(fontFamily: UiConfig.fontPrime),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, NFCTag tag) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'Delete Tag',
          style: TextStyle(fontFamily: UiConfig.fontPrime),
        ),
        content: Text(
          'Are you sure you want to delete this tag? This action cannot be undone.',
          style: TextStyle(fontFamily: UiConfig.fontPrime),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey,
                fontFamily: UiConfig.fontPrime,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              controller.deleteTag(tag.id);
              Get.back();
            },
            child: Text(
              'Delete',
              style: TextStyle(fontFamily: UiConfig.fontPrime),
            ),
          ),
        ],
      ),
    );
  }
}
