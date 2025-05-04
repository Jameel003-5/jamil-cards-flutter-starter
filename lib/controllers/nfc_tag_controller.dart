import 'package:get/get.dart';
import '../models/nfc_tag.dart';
import '../services/api_service.dart';

class NFCTagController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final RxList<NFCTag> tags = <NFCTag>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTags();
  }

  Future<void> fetchTags() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _apiService.get('/tags');
      final List<NFCTag> fetchedTags = (response as List)
          .map((tag) => NFCTag.fromJson(tag))
          .toList();
      
      tags.value = fetchedTags;
    } catch (e) {
      errorMessage.value = 'Failed to fetch tags: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> activateTag(String tagId, String userId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _apiService.post('/tags/$tagId/activate', {
        'userId': userId,
      });
      
      // Update the local tag state
      final tagIndex = tags.indexWhere((tag) => tag.id == tagId);
      if (tagIndex != -1) {
        final updatedTag = tags[tagIndex].copyWith(
          isActivated: true,
          assignedUserId: userId,
          activatedAt: DateTime.now(),
        );
        tags[tagIndex] = updatedTag;
      }

      Get.snackbar(
        'Success',
        'Tag activated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      errorMessage.value = 'Failed to activate tag: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deactivateTag(String tagId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _apiService.post('/tags/$tagId/deactivate', {});
      
      // Update the local tag state
      final tagIndex = tags.indexWhere((tag) => tag.id == tagId);
      if (tagIndex != -1) {
        final updatedTag = tags[tagIndex].copyWith(
          isActivated: false,
          assignedUserId: null,
          activatedAt: null,
        );
        tags[tagIndex] = updatedTag;
      }

      Get.snackbar(
        'Success',
        'Tag deactivated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      errorMessage.value = 'Failed to deactivate tag: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addTag(String uid) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final response = await _apiService.post('/tags', {
        'uid': uid,
      });
      
      final newTag = NFCTag.fromJson(response);
      tags.add(newTag);

      Get.snackbar(
        'Success',
        'Tag added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      errorMessage.value = 'Failed to add tag: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteTag(String tagId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      await _apiService.delete('/tags/$tagId');
      
      tags.removeWhere((tag) => tag.id == tagId);

      Get.snackbar(
        'Success',
        'Tag deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade50,
        colorText: Colors.green.shade900,
      );
    } catch (e) {
      errorMessage.value = 'Failed to delete tag: ${e.toString()}';
      Get.snackbar(
        'Error',
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade900,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
