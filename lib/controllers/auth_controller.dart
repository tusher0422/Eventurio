import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Uncomment in Phase 2 (Profile persistence)
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> firebaseUser = Rxn<User>();

  // Phase 2: Firestore instance
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.userChanges()); // reactive user
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await cred.user?.updateDisplayName(name);

      // 🔽 Phase 2: Save extra info to Firestore
      // if (cred.user != null) {
      //   await _firestore.collection("users").doc(cred.user!.uid).set({
      //     "uid": cred.user!.uid,
      //     "name": name,
      //     "email": email,
      //     "phone": phone ?? "",
      //     "address": address ?? "",
      //     "photoUrl": cred.user!.photoURL ?? "",
      //     "createdAt": FieldValue.serverTimestamp(),
      //   });
      // }

      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Signup Error", e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);

      // 🔽 Phase 2: Create or update Firestore profile
      // if (cred.user != null) {
      //   await _firestore.collection("users").doc(cred.user!.uid).set({
      //     "uid": cred.user!.uid,
      //     "name": cred.user!.displayName ?? "",
      //     "email": cred.user!.email ?? "",
      //     "phone": "",
      //     "address": "",
      //     "photoUrl": cred.user!.photoURL ?? "",
      //     "createdAt": FieldValue.serverTimestamp(),
      //   }, SetOptions(merge: true));
      // }

      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar("Google Sign-In Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAll(() => LoginScreen());
  }
}
