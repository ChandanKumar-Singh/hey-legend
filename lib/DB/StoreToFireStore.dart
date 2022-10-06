import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoreToFireStore {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  late SharedPreferences prefs;

  Future<String?> uploadFoldersImageAndGetUrl(
      {required String uid, required String file}) async {
    try {
      if (file != null) {
        Reference ref = await storage
            .ref('FoldersImage')
            .child(uid)
            .child(Random.secure().nextInt(1110000000).toString());
        var task = await ref.putFile(File(file));
        print('task ------------------ $task');

        var url = await ref.getDownloadURL();
        // await firestore.collection('users').doc(uid).update({'image': url});
        return url;
      }
    } catch (e) {
      print('pic upload error ------------------- $e');
    }
    return null;
  }

  Future<void> saveFolders(
      {required String folderName,
      required String image,
      required String type,
      required bool biometric,
      required CollectionReference reference}) async {
    prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    DocumentReference refer = reference.doc(folderName);
    var url = await uploadFoldersImageAndGetUrl(uid: uid!, file: image);
    await refer.set({
      'id': Random.secure().nextInt(1000000),
      'image': url,
      'type': type,
      'biometric': biometric,
      'time_stamp': DateTime.now()
    });
    // print(result);
  }

  Future<void> saveNotes(
      {required String title,
      required String note,
      required bool biometric,
      required DateTime updatedAt,
      required DocumentReference reference}) async {
    // prefs = await SharedPreferences.getInstance();
    // var uid = prefs.getString('uid');
    print(reference);
    await reference.set({
      'title': title,
      'note': note,
      'biometric': biometric,
      'createdAt': DateTime.now(),
      'updatedAt': updatedAt,
      'type': 'note'
    });
    // print(result);
  }

  Future<void> saveStore(
      {required String name,
      required String about,
      required String image,
      required String type,
      required bool biometric,
      required CollectionReference reference}) async {
    prefs = await SharedPreferences.getInstance();
    var uid = prefs.getString('uid');
    DocumentReference refer = reference.doc(name);
    print(refer);
    var url = await uploadFoldersImageAndGetUrl(uid: uid!, file: image);
    await refer.set({
      'id': refer.id,
      'name': name,
      'image': url,
      'type': 'store',
      'biometric': biometric,
      'about': about,
      'time_stamp': DateTime.now()
    });
    // print(result);
  }

  Stream<QuerySnapshot> getFolders(CollectionReference reference) async* {
    // prefs = await SharedPreferences.getInstance();
    // var uid = prefs.getString('uid');
    // CollectionReference reference =
    //     firestore.collection('users').doc(uid).collection('dashboard');
    var snap = await reference.snapshots();
    // print(snap.length);
    // print(uid);
    yield* snap;
  }

  Stream<QuerySnapshot> getNotes(
      {required CollectionReference reference}) async* {
    // prefs = await SharedPreferences.getInstance();
    // var uid = prefs.getString('uid');
    // print(reference);
    // await reference.update({
    //   'title': title,
    //   'note': note,
    //   'createdAt': DateTime.now(),
    //   'updatedAt': updatedAt
    // });
    // print(result);
    var snap = reference.orderBy('updatedAt').snapshots();
    print(snap.length);
    print(reference);
    yield* snap;
  }

  Stream<QuerySnapshot> getStore(
      {required CollectionReference reference}) async* {
    var snap = reference.orderBy('time_stmp').snapshots();
    print(snap.length);
    print(reference);
    yield* snap;
  }

  Future<void> deleteDoc(
      {required DocumentReference reference,
      required BuildContext context}) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Are you sure to delete?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'No',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await reference.delete().then(
                        (value) => Fluttertoast.showToast(msg: 'Deleted'));
                  },
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ));
  }

  Future<void> editDoc(
      {required DocumentReference reference,
      required Map<String, dynamic> data}) async {
    await reference.update(data);
  }

  Future<void> updateStore(
      {required String about,
      required CollectionReference reference,
      required String id}) async {
    DocumentReference refer = reference.doc(id);
    print(refer);
    await refer.update({
      'id': refer.id,
      'type': 'store',
      'about': about,
      'updatedAt': DateTime.now()
    });
    // print(result);
  }
}
