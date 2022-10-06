import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hey_legend/Auth/AuthController.dart';
import 'package:hey_legend/DB/StoreToFireStore.dart';
import 'package:hey_legend/Screens/DashBoard/DashBoardItems/ListingPage.dart';
import 'package:hey_legend/Screens/SplashScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String route = '/home';
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference reference;

  SharedPreferences? prefs;
  var uid;

  Future<CollectionReference> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      await prefs!.setString('uid', '9D1CKdcsWKUnQCpPLTX1GHi54Mm1');
      uid = prefs!.getString('uid');
      reference =
          firestore.collection('users').doc(uid).collection('dashboard');
      print(uid);
      return reference;
    } catch (e) {
      print('Home init error');
      rethrow;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    reference = firestore.collection('users').doc(uid).collection('dashboard');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    var dt = DateTime.now();
    return Scaffold(
      drawer: buildDrawer(theme),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipPath(
            clipper: WaveClipperTwo(flip: true, reverse: false),
            child: Container(
              height: s.height * 0.25,
              color: Colors.pink,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, bottom: 60),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dt.hour < 12
                                  ? 'Good Morning'
                                  : dt.hour < 16
                                      ? 'Good Afternoon'
                                      : dt.hour < 19
                                          ? 'Good Evening'
                                          : 'Good Night',
                              style: theme.textTheme.headline6!.copyWith(
                                  color: Colors.white, fontFamily: 'Georgia'),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Chandan Kumar Singh',
                              style: theme.textTheme.headline5!.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Georgia'),
                            ),
                          ],
                        ),
                        Column(
                          children: const [
                            Icon(
                              Icons.cloudy_snowing,
                              color: Colors.white,
                            ),
                            Text(
                              '22°C',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              'Cloud',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          FutureBuilder(
              future: init(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Text('Any Error'),
                  );
                } else {
                  if (reference != null) {
                    return StreamBuilder(
                      stream: StoreToFireStore().getFolders(reference),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snaps) {
                        if (snaps.hasError) {
                          return Center(
                            child: Text('Any Error'),
                          );
                        } else {
                          if (snaps.data != null) {
                            var data = snaps.data?.docs;
                            // print(snap.data);
                            // print(reference);

                            return Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: s.width * 0.05),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Start a new journey.',
                                          style: theme.textTheme.headline6,
                                        ),
                                        RaisedButton(
                                          onPressed: () async {
                                            await showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (context) {
                                                  return AddFolderDialog(
                                                    reference: reference,
                                                  );
                                                });
                                            //
                                          },
                                          child: const Text('Add Folder'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    // height: s.height * 0.6,
                                    child: GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                crossAxisSpacing:
                                                    s.width * 0.06,
                                                mainAxisSpacing:
                                                    s.width * 0.06),
                                        padding: EdgeInsets.only(
                                            left: s.width * 0.05,
                                            right: s.width * 0.05,
                                            top: s.width * 0.05,
                                            bottom: s.width * 0.05),
                                        itemCount: data!.length,
                                        itemBuilder: (context, i) {
                                          return buildFolderCards(theme, s,context: context,
                                              title: data[i].id,
                                              image: data[i]['image'],
                                              biometric: data[i]['biometric'],
                                              reference:
                                                  reference.doc(data[i].id),
                                              onTap: () async {
                                            var bm = await checkBiometric(
                                              biometric: data[i]['biometric'],
                                            );
                                            if (bm) {
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ListingPage(
                                                            folderName:
                                                                data[i].id,
                                                            reference:
                                                                reference,
                                                          )));
                                            }
                                          });
                                        }),
                                  )
                                ],
                              ),
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        }
                      },
                    );
                  } else {
                    print(reference);
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }
              }),
        ],
      ),
    );
  }

  Drawer buildDrawer(ThemeData theme) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            InkWell(
              onTap: () async {
                await Get.put(AuthController()).logOut();
              },
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: theme.backgroundColor),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.logout),
                      Text(
                        'Log Out',
                        style: theme.textTheme.headline6,
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ),
              ),
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}

Future<void> checkFolderBiometric(bool biometric, BuildContext context,
    CollectionReference reference, Widget page) async {
  if (biometric) {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (canAuthenticate) {
      final List<BiometricType> availableBiometrics =
          await auth.getAvailableBiometrics();
      if (availableBiometrics.contains(BiometricType.strong) ||
          availableBiometrics.contains(BiometricType.face)) {
        try {
          final bool didAuthenticate = await auth.authenticate(
              localizedReason: 'Please authenticate to enter to this folder.');
          if (didAuthenticate) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => page));
          } else {
            // Navigator.pop(context);
            Fluttertoast.showToast(msg: 'Could\'nt authenticate.');
          }
        } on PlatformException catch (e) {
          print(e);
          Fluttertoast.showToast(msg: e.message!);
          // ...
        }
      }
    }
  } else {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => page));
  }
}

class AddFolderDialog extends StatefulWidget {
  const AddFolderDialog({Key? key, required this.reference}) : super(key: key);
  final CollectionReference reference;
  @override
  State<AddFolderDialog> createState() => _AddFolderDialogState();
}

class _AddFolderDialogState extends State<AddFolderDialog> {
  TextEditingController folderName = TextEditingController();
  var image = '';
  bool dropdown = false;
  bool biometric = false;
  final List<String> items = [
    'Notes',
    'Listing',
    'Store',
  ];
  String? selectedValue;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    var dt = DateTime.now();
    print(dt);
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: theme.cardColor,
        ),
        height: s.width * 0.7,
        width: s.width / 1.5,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: folderName,
                  decoration:
                      const InputDecoration(labelText: 'Enter Collection Name'),
                  maxLength: 15,
                ),
                Row(
                  children: [
                    RaisedButton(
                      color: biometric ? Colors.green : theme.buttonColor,
                      onPressed: () async {
                        setState(() {
                          biometric = !biometric;
                        });
                      },
                      child: const Text(
                        'Biometric',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            var img = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 90,
                                maxHeight: 200,
                                maxWidth: 200);
                            if (img != null) {
                              setState(() {
                                image = img.path;
                              });
                            }
                          },
                          child: const Text(
                            '+ Add Image',
                          ),
                        ),
                        if (image != '')
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: const Icon(
                              Icons.done_all,
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              Icon(
                                Icons.list,
                                // size: 16,
                                // color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Type',
                                  style: TextStyle(
                                    // fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.yellow,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        // fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          // iconSize: 14,
                          // iconEnabledColor: Colors.yellow,
                          // iconDisabledColor: Colors.grey,
                          // buttonHeight: 50,
                          buttonWidth: 160,
                          buttonPadding:
                              const EdgeInsets.only(left: 14, right: 14),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            // color: Colors.redAccent,
                          ),
                          buttonElevation: 2,
                          itemHeight: 40,
                          itemPadding:
                              const EdgeInsets.only(left: 14, right: 14),
                          dropdownMaxHeight: 200,
                          // dropdownWidth: 200,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(-20, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          image = '';
                          folderName.clear();
                        });
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        if (folderName.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Folder name is empty.',
                              textColor: Colors.red);
                        } else if (image == '') {
                          Fluttertoast.showToast(
                              msg: 'Please select an image.',
                              textColor: Colors.red);
                        } else if (selectedValue == null) {
                          Fluttertoast.showToast(
                              msg: 'Please select a file type.',
                              textColor: Colors.red);
                        } else {
                          setState(() {
                            dropdown = true;
                          });
                          await StoreToFireStore()
                              .saveFolders(
                                  folderName: folderName.text,
                                  image: image,
                                  type: selectedValue!,
                                  biometric: biometric,
                                  reference: widget.reference)
                              .then((value) => print('Folder Saved'))
                              .then((value) => Navigator.pop(context))
                              .then((value) => setState(() {
                                    image = '';
                                    folderName.clear();
                                  }))
                              .then((value) => setState(() {
                                    dropdown = false;
                                  }));
                        }
                      },
                      color: Colors.green,
                      child: Text(
                        '+ Create',
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (dropdown)
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                height: s.width / 2,
                width: s.width / 1.5,
              ),
          ],
        ),
      ),
    );
  }
}

class AddNoteDialog extends StatefulWidget {
  const AddNoteDialog(
      {Key? key, required this.reference, required this.folderName})
      : super(key: key);
  final CollectionReference reference;
  final String folderName;
  @override
  State<AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  bool biometric = false;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    var dt = DateTime.now();
    // print(dt);
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: s.height * 0.7,
        width: s.width * 0.9,
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: title,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: UnderlineInputBorder()
                          .copyWith(borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: UnderlineInputBorder().copyWith(
                          borderSide: BorderSide(color: Colors.grey))),
                  maxLength: 200,
                ),
                Expanded(
                  child: TextFormField(
                    controller: note,
                    decoration: const InputDecoration(
                        hintText: 'Write here',
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none),
                    maxLines: 100000,
                  ),
                ),
                Row(
                  children: [
                    RaisedButton(
                      color: biometric ? Colors.green : theme.buttonColor,
                      onPressed: () async {
                        setState(() {
                          biometric = !biometric;
                        });
                      },
                      child: const Text(
                        'Biometric',
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      child: Text(
                        'Cancel',
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        await StoreToFireStore()
                            .saveNotes(
                                title: title.text,
                                note: note.text,
                                reference: widget.reference
                                    .doc(widget.folderName)
                                    .collection('notes')
                                    .doc(title.text),
                                biometric: biometric,
                                updatedAt: DateTime.now())
                            .then((value) => print('Note Saved'))
                            .then((value) => Navigator.pop(context));
                      },
                      color: Colors.green,
                      child: Text(
                        'Done',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditNoteDialog extends StatefulWidget {
  const EditNoteDialog(
      {Key? key,
      required this.reference,
      required this.title,
      required this.note})
      : super(key: key);
  final DocumentReference reference;
  final String title;
  final String note;
  @override
  State<EditNoteDialog> createState() => _EditNoteDialogState();
}

class _EditNoteDialogState extends State<EditNoteDialog> {
  TextEditingController title = TextEditingController();
  TextEditingController note = TextEditingController();
  @override
  void initState() {
    super.initState();
    title.text = widget.title;
    note.text = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    var dt = DateTime.now();
    // print(dt);
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: s.height * 0.7,
        width: s.width * 0.9,
        child: Stack(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: title,
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Title',
                      border: UnderlineInputBorder()
                          .copyWith(borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: UnderlineInputBorder().copyWith(
                          borderSide: BorderSide(color: Colors.grey))),
                  maxLength: 200,
                ),
                Expanded(
                  child: TextFormField(
                    controller: note,
                    decoration: const InputDecoration(
                        hintText: 'Write here',
                        enabledBorder: InputBorder.none,
                        border: InputBorder.none),
                    maxLines: 100000,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      onPressed: () async {
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      child: Text(
                        'Cancel',
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        var data = {
                          'title': title.text,
                          'note': note.text,
                          'updatedAt': DateTime.now()
                        };
                        await StoreToFireStore()
                            .editDoc(reference: widget.reference, data: data)
                            .then((value) => print('Note Saved'))
                            .then((value) => Navigator.pop(context));
                      },
                      color: Colors.green,
                      child: Text(
                        'Done',
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AddStoreDialog extends StatefulWidget {
  const AddStoreDialog({
    Key? key,
    required this.reference,
  }) : super(key: key);
  final CollectionReference reference;

  @override
  State<AddStoreDialog> createState() => _AddStoreDialogState();
}

class _AddStoreDialogState extends State<AddStoreDialog> {
  TextEditingController folderName = TextEditingController();
  TextEditingController about = TextEditingController();
  var image = '';
  bool dropdown = false;
  bool biometric = false;
  final List<String> items = [
    'Notes',
    'Listing',
    'Store',
  ];
  String selectedValue = 'Store';
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    var dt = DateTime.now();
    print(dt);
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: s.width * 0.8,
        width: s.width / 1.5,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextFormField(
                  controller: folderName,
                  decoration: const InputDecoration(labelText: 'Name'),
                  maxLength: 15,
                ),
                TextFormField(
                  controller: about,
                  decoration: const InputDecoration(labelText: 'About '),
                  maxLength: 30,
                ),
                Row(
                  children: [
                    RaisedButton(
                      color: biometric ? Colors.green : theme.buttonColor,
                      onPressed: () async {
                        setState(() {
                          biometric = !biometric;
                        });
                      },
                      child: const Text(
                        'Biometric',
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Stack(
                      children: [
                        RaisedButton(
                          onPressed: () async {
                            var img = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 90,
                                maxHeight: 200,
                                maxWidth: 200);
                            if (img != null) {
                              setState(() {
                                image = img.path;
                              });
                            }
                          },
                          child: const Text(
                            '+ Add Image',
                          ),
                        ),
                        if (image != '')
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: const Icon(
                              Icons.done_all,
                              color: Colors.green,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton2(
                          isExpanded: true,
                          hint: Row(
                            children: const [
                              Icon(
                                Icons.list,
                                // size: 16,
                                // color: Colors.yellow,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  'Type',
                                  style: TextStyle(
                                    // fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.yellow,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                    value: item,
                                    child: Text(
                                      item,
                                      style: const TextStyle(
                                        // fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ))
                              .toList(),
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value as String;
                            });
                          },
                          icon: const Icon(
                            Icons.arrow_forward_ios_outlined,
                          ),
                          // iconSize: 14,
                          // iconEnabledColor: Colors.yellow,
                          // iconDisabledColor: Colors.grey,
                          // buttonHeight: 50,
                          buttonWidth: 160,
                          buttonPadding:
                              const EdgeInsets.only(left: 14, right: 14),
                          buttonDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: Colors.black26,
                            ),
                            // color: Colors.redAccent,
                          ),
                          buttonElevation: 2,
                          itemHeight: 40,
                          itemPadding:
                              const EdgeInsets.only(left: 14, right: 14),
                          dropdownMaxHeight: 200,
                          // dropdownWidth: 200,
                          dropdownPadding: null,
                          dropdownDecoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.grey,
                          ),
                          dropdownElevation: 8,
                          scrollbarRadius: const Radius.circular(40),
                          scrollbarThickness: 6,
                          scrollbarAlwaysShow: true,
                          offset: const Offset(-20, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FlatButton(
                      onPressed: () {
                        setState(() {
                          image = '';
                          about.clear();
                        });
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                      child: const Text(
                        'Cancel',
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        if (folderName.text.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'File name is empty.',
                              textColor: Colors.red);
                        } else if (image == '') {
                          Fluttertoast.showToast(
                              msg: 'Please select an image.',
                              textColor: Colors.red);
                        } else if (selectedValue == null) {
                          Fluttertoast.showToast(
                              msg: 'Please select a file type.',
                              textColor: Colors.red);
                        } else {
                          setState(() {
                            dropdown = true;
                          });
                          await StoreToFireStore()
                              .saveStore(
                                  name: folderName.text,
                                  about: about.text,
                                  image: image,
                                  type: selectedValue,
                                  biometric: biometric,
                                  reference: widget.reference)
                              .then((value) => print('File Saved'))
                              .then((value) => Navigator.pop(context))
                              .then((value) => setState(() {
                                    image = '';
                                    about.clear();
                                  }))
                              .then((value) => setState(() {
                                    dropdown = false;
                                  }));
                        }
                      },
                      color: Colors.green,
                      child: Text(
                        '+ Create',
                      ),
                    ),
                  ],
                )
              ],
            ),
            if (dropdown)
              Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                height: s.width / 2,
                width: s.width / 1.5,
              ),
          ],
        ),
      ),
    );
  }
}

class ViewStoreDialog extends StatefulWidget {
  const ViewStoreDialog({
    Key? key,
    required this.reference,
    required this.id,
    required this.image,
    required this.about,
  }) : super(key: key);
  final CollectionReference reference;
  final String id;
  final String image;
  final String about;

  @override
  State<ViewStoreDialog> createState() => _ViewStoreDialogState();
}

class _ViewStoreDialogState extends State<ViewStoreDialog> {
  TextEditingController about = TextEditingController();
  @override
  void initState() {
    super.initState();
    about.text = widget.about;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        // padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: s.height,
        width: s.width,
        child: Stack(
          children: [
            Container(
              height: s.height,
              width: s.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  image: DecorationImage(
                      image: NetworkImage(widget.image), fit: BoxFit.fitWidth)),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextFormField(
                    controller: about,
                    decoration: InputDecoration(
                        hintText: 'About ',
                        fillColor: Colors.grey[300],
                        filled: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25))),
                    maxLength: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        onPressed: () {
                          setState(() {
                            about.clear();
                          });
                          Navigator.pop(context);
                        },
                        color: Colors.red,
                        child: const Text(
                          'Cancel',
                        ),
                      ),
                      FlatButton(
                        onPressed: () async {
                          await StoreToFireStore()
                              .updateStore(
                                  id: widget.id,
                                  about: about.text,
                                  reference: widget.reference)
                              .then((value) => print('File Updated'))
                              .then((value) => Navigator.pop(context));
                        },
                        color: Colors.green,
                        child: Text(
                          'Update',
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
