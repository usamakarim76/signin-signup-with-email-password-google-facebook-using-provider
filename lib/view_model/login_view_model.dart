import 'package:example/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginViewModel extends ChangeNotifier {
  BuildContext context;
  LoginViewModel(this.context);

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  bool isLoading = false, isGoogleLoading = false;

  Future<void> signIn() async {
    try {
      isLoading = true;
      notifyListeners();
      await auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      isLoading = false;
      notifyListeners();
      Utils.successMessage(context, "Log in successfully");
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future<void> googleSignIn() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      googleSignIn.signOut();
      isGoogleLoading = true;
      notifyListeners();
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential authCredential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);
        UserCredential result = await auth.signInWithCredential(authCredential);
        User? user = result.user;
        Utils.successMessage(context, "Log in successfully");
        isGoogleLoading = false;
        notifyListeners();
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoading = false;
      notifyListeners();
      Utils.errorMessage(context, e.message);
    }
  }
}
