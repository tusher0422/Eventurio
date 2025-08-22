import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'auth_controller.dart';
import '../models/event_model.dart';

class EventController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RxList<Event> events = <Event>[].obs;
  final RxBool isLoading = false.obs;
  final RxString activeFilter = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('events')
          .orderBy('date', descending: false)
          .get();

      events.assignAll(
        snapshot.docs.map((doc) => Event.fromDoc(doc)).toList(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEventsByCategory(String category) async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('events')
          .where('category', isEqualTo: category)
          .get();

      events.assignAll(
        snapshot.docs.map((doc) => Event.fromDoc(doc)).toList(),
      );
      activeFilter.value = category;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMyEvents() async {
    final userId = Get.find<AuthController>().firebaseUser.value?.uid;
    if (userId == null) return;

    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('events')
          .where('attendees', arrayContains: userId)
          .get();

      final createdSnapshot = await _firestore
          .collection('events')
          .where('createdBy', isEqualTo: userId)
          .get();

      final all = [
        ...snapshot.docs.map((doc) => Event.fromDoc(doc)),
        ...createdSnapshot.docs.map((doc) => Event.fromDoc(doc)),
      ];

      final unique = {for (var e in all) e.id: e}.values.toList();

      events.assignAll(unique);
      activeFilter.value = "my";
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createEvent(Event event) async {
    await _firestore.collection('events').add(event.toJson());
    await fetchEvents();
  }

  Future<void> updateEvent(Event event) async {
    await _firestore.collection('events').doc(event.id).update(event.toJson());
    await fetchEvents();
  }

  Future<void> deleteEvent(String eventId) async {
    await _firestore.collection('events').doc(eventId).delete();
    events.removeWhere((e) => e.id == eventId);
  }

  Future<void> attendEvent(String eventId) async {
    final userId = Get.find<AuthController>().firebaseUser.value?.uid;
    if (userId == null) return;

    await _firestore.collection('events').doc(eventId).update({
      'attendees': FieldValue.arrayUnion([userId]),
    });
    await fetchEvents();
  }

  Future<void> cancelAttendance(String eventId) async {
    final userId = Get.find<AuthController>().firebaseUser.value?.uid;
    if (userId == null) return;

    await _firestore.collection('events').doc(eventId).update({
      'attendees': FieldValue.arrayRemove([userId]),
    });
    await fetchEvents();
  }


  bool isAttending(Event event) {
    final userId = Get.find<AuthController>().firebaseUser.value?.uid;
    if (userId == null) return false;
    return event.attendees.contains(userId);
  }


  bool isAdmin() {
    final role = Get.find<AuthController>().userProfile['userRole'] ?? 'user';
    return role == 'admin';
  }
}
