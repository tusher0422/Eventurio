import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/event_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  const EventDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Get.find<EventController>();
    final authController = Get.find<AuthController>();
    final Event event = Get.arguments as Event;

    final bool isCreator =
        authController.firebaseUser.value?.uid == event.createdBy;

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.deepPurple,
        actions: [
          Obx(() {
            final bool isAdmin = eventController.isAdmin();
            if (!isAdmin && !isCreator) return const SizedBox.shrink();

            return PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == "edit") {
                  Get.toNamed("/event/edit/${event.id}", arguments: event);
                } else if (value == "delete") {
                  final confirm = await Get.defaultDialog<bool>(
                    title: "Confirm Delete",
                    middleText: "Are you sure you want to delete this event?",
                    textCancel: "No",
                    textConfirm: "Yes",
                    confirmTextColor: Colors.white,
                    onConfirm: () => Get.back(result: true),
                    onCancel: () => Get.back(result: false),
                  );
                  if (confirm == true) {
                    await eventController.deleteEvent(event.id!);
                    Get.back(); // back to home
                    Get.snackbar(
                      "Deleted",
                      "Event deleted successfully",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: "edit", child: Text("Edit")),
                PopupMenuItem(value: "delete", child: Text("Delete")),
              ],
            );
          }),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(label: Text(event.category), backgroundColor: Colors.deepPurple),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: event.isPaid ? Colors.redAccent : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  event.isPaid ? "Paid" : "Free",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 6),
              Text("${event.date.toLocal()}".split(" ")[0], style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 20),
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 6),
              Expanded(child: Text(event.location, style: const TextStyle(fontSize: 14))),
            ],
          ),
          const SizedBox(height: 20),
          Text("Description", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(event.description, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 20),
          if (event.isPaid && event.price != null)
            Text("Price: \$${event.price!.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          if (event.isPaid) const SizedBox(height: 20),
          Text("Attendees: ${event.attendees.length}", style: const TextStyle(fontSize: 14, color: Colors.black54)),
          const SizedBox(height: 20),
          Center(
            child: Obx(() {
              final isAttending = eventController.isAttending(event);
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAttending ? Colors.grey : Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  if (isAttending) {
                    final confirm = await Get.defaultDialog<bool>(
                      title: "Confirm",
                      middleText: "Are you sure you want to cancel attendance?",
                      textCancel: "No",
                      textConfirm: "Yes",
                      confirmTextColor: Colors.white,
                      onConfirm: () => Get.back(result: true),
                      onCancel: () => Get.back(result: false),
                    );
                    if (confirm == true) {
                      await eventController.cancelAttendance(event.id!);
                      Get.back();
                      Get.snackbar(
                        "Cancelled",
                        "Your attendance for ${event.title} is cancelled",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  } else {
                    await eventController.attendEvent(event.id!);
                    Get.back();
                    Get.snackbar(
                      "Success",
                      "You are now attending ${event.title}",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  }
                },
                child: Text(isAttending ? "Cancel Attendance" : "Attend Event",
                    style: const TextStyle(color: Colors.white)),
              );
            }),
          ),
        ]),
      ),
    );
  }
}
