import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/event_controller.dart';
import '../widgets/drawer_header_widget.dart';
import '../widgets/event_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final themeController = Get.find<ThemeController>();
    final eventController = Get.put(EventController());
    final user = FirebaseAuth.instance.currentUser;
    final drawerKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: drawerKey,
      appBar: AppBar(
        title: const Text("Eventurio Home"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: CircleAvatar(
              backgroundImage:
              user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
              child: user?.photoURL == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            onPressed: () => drawerKey.currentState?.openEndDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => drawerKey.currentState?.openEndDrawer(),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Column(
          children: [
            DrawerHeaderWidget(),
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Theme"),
              trailing: Obx(() => Switch(
                value: themeController.isDark.value,
                onChanged: (val) => themeController.toggleTheme(),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.event),
              title: const Text("My Events"),
              onTap: () async {
                Navigator.pop(context); // close drawer
                await eventController.fetchMyEvents();
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text("All Events"),
              onTap: () async {
                Navigator.pop(context);
                await eventController.fetchEvents();
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () => authController.logout(),
            ),
          ],
        ),
      ),
      body: Obx(() {
        if (eventController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (eventController.events.isEmpty) {
          return const Center(
            child: Text(
              "No events yet. Create the first one!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () => eventController.fetchEvents(),
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemCount: eventController.events.length,
            itemBuilder: (context, index) {
              final event = eventController.events[index];
              return EventCard(event: event);
            },
          ),
        );
      }),
      floatingActionButton: Obx(() {
        if (eventController.isAdmin() ||
            authController.firebaseUser.value != null) {
          return FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            child: const Icon(Icons.add),
            onPressed: () {
              Get.toNamed("/event/create");
            },
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
