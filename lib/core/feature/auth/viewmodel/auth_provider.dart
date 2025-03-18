import 'package:devwidget/core/feature/auth/view/login_screen.dart';
import 'package:devwidget/navigation/BottomNavScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

///auth class
class AuthState {
  final bool isLoading;
  final String? errorMessage;
  final User? user;

  AuthState({this.isLoading = false, this.errorMessage, this.user});
}

///Auth Controller using StateNotifier
class AuthController extends StateNotifier<AuthState> {
  final Ref ref;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthController(this.ref) : super(AuthState());

  ///Check USer Login Status
  /* void checkUserLoginStatus(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedEmail = prefs.getString('email');
    String? storedName = prefs.getString('name');

    User? user = _auth.currentUser;
    if (user != null) {
      state = AuthState(user: user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
    } else if (storedEmail != null && storedName != null) {
      // If credentials are stored in SharedPreferences
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: storedEmail,
        password: '', // You can add password logic here if needed
      );
      state = AuthState(user: userCredential.user);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }*/

  ///Register User
  Future<void> register(
      String email, String password, String name, BuildContext context) async {
    try {
      state = AuthState(isLoading: true);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      state = AuthState(user: userCredential.user);

      ///Store email and name in SharedPreference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('name', name);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
    } on FirebaseAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    }
  }

  ///login User
  Future<void> login(
      String email, String password, BuildContext context) async {
    try {
      state = AuthState(isLoading: true);
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      state = AuthState(user: userCredential.user);

      ///Store email and name in SharedPreference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);
      await prefs.setString('name', userCredential.user?.displayName ?? '');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
    } on FirebaseAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    }
  }

  /// Google Sign-In
  Future<void> googleSignIn(BuildContext context) async {
    try {
      state = AuthState(isLoading: true);
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        state = AuthState(errorMessage: 'Google Sign-In Canceled');
        return;
      }
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      state = AuthState(user: userCredential.user);

      ///Store email and name in SharedPreference
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', userCredential.user?.email ?? '');
      await prefs.setString('name', userCredential.user?.displayName ?? '');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => BottomNavScreen()));
    } on FirebaseAuthException catch (e) {
      state = AuthState(errorMessage: e.message);
    }
  }

  /// Logout User
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    await _googleSignIn.signOut();

    ///Store email and name in SharedPreference
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('email');
    await prefs.remove('name');
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

/*state = AuthState(user: null);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }*/
}

/// Riverpod Provider
final authProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
