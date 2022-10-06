import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../FireBaseConstants.dart';

class UserInitialization {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createUser(
      {required String uid,
      String? name,
      String? contact,
      required String password}) async {
    var data = {
      'name': name!,
      'uid': uid,
      'image': '',
      'age': '',
      'collegeName': '',
      'semesterName': '',
      'bio': '',
      'contact': contact!,
    };
    DocumentReference reference = firestore.collection('users').doc(uid);
    var result = await reference.set(data);
    Fluttertoast.showToast(msg: 'SuccessFully Registered');
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', jsonEncode(data));
    await prefs.setString('uid', uid);
    var user = prefs.getString('user_info');
    print('------------------ $user initialised');
    // await getUser(uid: uid);
  }

  Future<void> getUser({required String uid}) async {
    DocumentSnapshot snap = await firestore.collection('users').doc(uid).get();
    // var result = jsonDecode(snap.data());
    // Fluttertoast.showToast(msg: 'SuccessFully Registered');
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_info', snap.data().toString());
    await prefs.setString('uid', uid);

    var u = prefs.getString('uid');
    print('---------Snap Data--------- ${snap.data()}');
    print('---------uid--------- $u');
  }

  Future<String?> uploadImageAndGetUrl(
      {required String uid, required String file}) async {
    try {
      if (file != null) {
        Reference ref =
            await storage.ref(profilePicRef).child(uid).child('ProfilePic');
        var task = await ref.putFile(File(file));
        print('task ------------------ $task');

        var url = await ref.getDownloadURL();
        await firestore.collection('users').doc(uid).update({'image': url});
        return url;
      }
    } catch (e) {
      print('pic upload error ------------------- $e');
    }
    return null;
  }
}
