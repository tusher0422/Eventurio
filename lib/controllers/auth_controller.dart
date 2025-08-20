import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// Phase 2 (Profile persistence with Firestore)
// import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> firebaseUser = Rxn<User>();

  // Phase 2
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.userChanges()); // reactive user tracking
  }

  /// ----------------- SIGN UP -----------------
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

      // Update display name
      await cred.user?.updateDisplayName(name);

      // 🔽 Phase 2: Store extra profile data
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
      _showError("Signup Error", e.message);
    } catch (e) {
      _showError("Signup Error", e.toString());
    }
  }

  /// ----------------- LOGIN -----------------
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => const HomeScreen());
    } on FirebaseAuthException catch (e) {
      _showError("Login Error", e.message);
    } catch (e) {
      _showError("Login Error", e.toString());
    }
  }

  /// ----------------- GOOGLE SIGN IN -----------------
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // cancelled

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final cred = await _auth.signInWithCredential(credential);

      // 🔽 Phase 2: Save profile
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
    } on FirebaseAuthException catch (e) {
      _showError("Google Sign-In Error", e.message);
    } catch (e) {
      _showError("Google Sign-In Error", e.toString());
    }
  }

  /// ----------------- LOGOUT -----------------
  Future<void> logout() async {
    try {
      await _auth.signOut();
      await GoogleSignIn().signOut();
      Get.offAll(() => LoginScreen());
    } catch (e) {
      _showError("Logout Error", e.toString());
    }
  }

  /// ----------------- ERROR HANDLER -----------------
  void _showError(String title, String? message) {
    Get.snackbar(
      title,
      message ?? "Something went wrong",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
    );
  }
}
