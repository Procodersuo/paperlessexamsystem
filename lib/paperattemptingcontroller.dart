import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AttemptController extends GetxController {
  final RxList<Map<String, dynamic>> papers = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  Future<void> fetchAvailablePapers({
    required String department,
    required String semester,
    required String section,
  }) async {
    isLoading.value = true;
    try {
      final now = Timestamp.now();

      final query = await FirebaseFirestore.instance
          .collection('papers')
          .where('department', isEqualTo: department)
          .where('semester', isEqualTo: semester)
          .where('section', isEqualTo: section)
          .where('visibleAt', isLessThanOrEqualTo: now)
          .get();

      papers.clear();
      for (var doc in query.docs) {
        papers.add(doc.data());
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load papers");
    } finally {
      isLoading.value = false;
    }
  }
}
