import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:example/model/model.dart';
import 'package:example/resources/constants.dart';
import 'package:example/utils/routes/route_name.dart';
import 'package:example/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUpViewModel extends ChangeNotifier {
  BuildContext context;
  SignUpViewModel(this.context);

  final emailController = TextEditingController();
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  FocusNode emailNode = FocusNode();
  FocusNode userNameNode = FocusNode();
  FocusNode passwordNode = FocusNode();
  ValueNotifier<bool> obscureText = ValueNotifier<bool>(true);
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  bool isLoading = false, isGoogleLoading = false;

  Future registerUser() async {
    try {
      isLoading = true;
      notifyListeners();
      await auth
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      )
          .then((value) {
        dataToFirestore(userNameController.text, emailController.text);
        userNameController.clear();
        emailController.clear();
        passwordController.clear();
        isLoading = false;
        notifyListeners();
      });
      Utils.successMessage(context, "Registered Successfully");
      Navigator.pushNamedAndRemoveUntil(
          context, RouteNames.loginScreen, (route) => false);
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      notifyListeners();
      error = e.message!;
      Utils.errorMessage(context, error);
    }
  }

  Future dataToFirestore(name, email) async {
    await firestore
        .collection(AppConstants.collectionName)
        .doc(auth.currentUser!.uid)
        .set({
      'Name': name,
      'Email': email,
    });
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
        dataToFirestore(user!.displayName, user.email);
        Utils.successMessage(context, "Log in successfully");
        isGoogleLoading = false;
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
            context, RouteNames.mainScreen, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      isGoogleLoading = false;
      notifyListeners();
      Utils.errorMessage(context, e.message);
    }
  }

  Future<Resource?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      switch (result.status) {
        case LoginStatus.success:
          final AuthCredential facebookCredential =
              FacebookAuthProvider.credential(result.accessToken!.token);
          final userCredential =
              await auth.signInWithCredential(facebookCredential);
          return Resource(status: Status.Success);
        case LoginStatus.cancelled:
          return Resource(status: Status.Cancelled);
        case LoginStatus.failed:
          return Resource(status: Status.Error);
        default:
          return null;
      }
    } on FirebaseAuthException catch (e) {
      // throw e.message;
      Utils.errorMessage(context, e.message);
      throw e;
    }
  }
}
