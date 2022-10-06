import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hey_legend/DB/userInitialization.dart';
import 'package:hey_legend/Model/UserModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/OnBoarding/OnBoarding.dart';

class AuthController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  GoogleSignIn signIn = GoogleSignIn();
  UserModel? userModel;

  Future<void> registrationFromEmail(
      {required String name,
      required String userName,
      required String contact,
      required String password}) async {
    var result = await auth.createUserWithEmailAndPassword(
        email: userName, password: password);
    print(result.user!.uid);
    print(result.user);

    await UserInitialization()
        .createUser(
            uid: result.user!.uid,
            name: name,
            contact: contact,
            password: password)
        .then((value) => print('---- user created'));
    var prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('uid', result.user!.uid)
        .then((value) => print('uid saved to local device'));
    print('Shared Preferences --> uid ${prefs.getString('uid')}');
  }

  Future<void> loginFromEmail(
      {required String userName, required String password}) async {
    var result = await auth.signInWithEmailAndPassword(
        email: userName, password: password);
    print(result.user!.uid);
    print(result.user);
    print('---- user Logined');
    await UserInitialization().getUser(uid: result.user!.uid);
    var prefs = await SharedPreferences.getInstance();
    await prefs
        .setString('uid', result.user!.uid)
        .then((value) => print('uid saved to local device'));
    print('Shared Preferences --> uid ${prefs.getString('uid')}');
  }

  Future<void> logOut() async {
    await auth.signOut();
    var prefs = await SharedPreferences.getInstance();
    await prefs
        .clear()
        .then((value) => print('uid cleared from local device'))
        .then((value) =>
            print('Shared Preferences --> uid ${prefs.getString('uid')}'))
        .then((value) => Get.offAll(OnBoarding1()));
  }
}
