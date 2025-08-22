import 'package:eventurio/app/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final Rxn<User> firebaseUser = Rxn<User>();
  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _loadUserProfile);
  }

  Future<void> _loadUserProfile(User? user) async {
    if (user == null) {
      userProfile.clear();
      return;
    }

    final doc = await _firestore.collection("users").doc(user.uid).get();
    if (doc.exists) {
      userProfile.assignAll(doc.data()!);
    } else {
      final newUser = {
        "uid": user.uid,
        "name": user.displayName ?? "",
        "email": user.email ?? "",
        "phone": "",
        "address": "",
        "photoUrl": user.photoURL ?? "",
        "createdAt": FieldValue.serverTimestamp(),
      };
      await _firestore.collection("users").doc(user.uid).set(newUser);
      userProfile.assignAll(newUser);
    }
  }

  String get userName =>
      userProfile["name"] ?? firebaseUser.value?.displayName ?? "";
  String get userEmail =>
      userProfile["email"] ?? firebaseUser.value?.email ?? "";
  String get userPhoto =>
      userProfile["photoUrl"] ?? firebaseUser.value?.photoURL ?? "";
  String get userPhone => userProfile["phone"] ?? "";
  String get userAddress => userProfile["address"] ?? "";

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await cred.user?.updateDisplayName(name);
      await _loadUserProfile(cred.user);
      Get.offAllNamed(Routes.home);
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
      await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      Get.offAllNamed(Routes.home);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Login Error", e.message ?? "Unknown error",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
      await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
      await _auth.signInWithCredential(credential);
      await _loadUserProfile(userCredential.user);
      Get.offAllNamed(Routes.home);
    } catch (e) {
      Get.snackbar("Google Sign-In Error", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed(Routes.login);
  }

  Future<void> updateProfile({
    required String name,
    required String phone,
    String? address,
  }) async {
    final user = firebaseUser.value;
    if (user == null) return;

    await user.updateDisplayName(name);
    await _firestore.collection("users").doc(user.uid).set({
      "name": name,
      "phone": phone,
      "address": address ?? "",
      "photoUrl": user.photoURL ?? "",
      "email": user.email ?? "",
    }, SetOptions(merge: true));

    userProfile["name"] = name;
    userProfile["phone"] = phone;
    userProfile["address"] = address ?? "";
  }
}
