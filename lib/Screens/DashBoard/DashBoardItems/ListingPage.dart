import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hey_legend/DB/StoreToFireStore.dart';
import 'package:local_auth/local_auth.dart';

import '../HomePage.dart';

class ListingPage extends StatefulWidget {
  const ListingPage(
      {Key? key, required this.folderName, required this.reference})
      : super(key: key);
  final String folderName;
  final CollectionReference reference;
  @override
  State<ListingPage> createState() => _ListingPageState();
}

class _ListingPageState extends State<ListingPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference folderReference;
  late CollectionReference notesReference;
  late CollectionReference storeReference;
  int curIndex = 0;
  @override
  void initState() {
    super.initState();
    folderReference =
        widget.reference.doc(widget.folderName).collection('inside');
    notesReference =
        widget.reference.doc(widget.folderName).collection('notes');
    storeReference =
        widget.reference.doc(widget.folderName).collection('store');
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    // var dt = DateTime.now();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.folderName),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: s.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                RaisedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AddFolderDialog(
                            reference: folderReference,
                          );
                        });
                    //
                  },
                  child: const Text('Add Folder'),
                ),
                SizedBox(width: 20),
                RaisedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AddNoteDialog(
                            reference: widget.reference,
                            folderName: widget.folderName,
                          );
                        });
                    //
                  },
                  child: const Text('Add Note'),
                ),
                SizedBox(width: 20),
                RaisedButton(
                  onPressed: () async {
                    await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return AddStoreDialog(
                            reference: storeReference,
                          );
                        });
                    //
                  },
                  child: const Text('Add Files'),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: s.width * 0.05),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                    onTap: () {
                      setState(() {
                        curIndex = 0;
                      });
                    },
                    child: Chip(
                      label: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Folders',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      avatar: Icon(Icons.folder),
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        curIndex = 1;
                      });
                    },
                    child: Chip(
                      label: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Notes',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      avatar: Icon(Icons.notes),
                    )),
                InkWell(
                    onTap: () {
                      setState(() {
                        curIndex = 2;
                      });
                    },
                    child: Chip(
                      label: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          'Store',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ),
                      avatar: Icon(Icons.store),
                    )),
              ],
            ),
          ),
          if (curIndex == 0)
            StreamBuilder(
                stream: StoreToFireStore().getFolders(folderReference),
                builder: (context, AsyncSnapshot<QuerySnapshot> snaps) {
                  if (snaps.hasError) {
                    return Center(
                      child: Text('Any Error'),
                    );
                  } else {
                    if (snaps.data!.docs.isNotEmpty) {
                      var data = snaps.data?.docs.reversed.toList();
                      // print(data);
                      return Expanded(
                        // height: s.height * 0.6,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: s.width * 0.06,
                                    childAspectRatio: 2,
                                    mainAxisSpacing: s.width * 0.06),
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
                                  reference: folderReference.doc(data[i].id),
                                  onTap: () async {
                                var bm = await checkBiometric(
                                  biometric: data[i]['biometric'],
                                );
                                if (bm) {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ListingPage(
                                          folderName: data[i].id,
                                          reference: widget.reference
                                              .doc('inside')
                                              .collection(
                                                widget.folderName,
                                              ))));
                                }
                              });
                            }),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                }),
          if (curIndex == 1)
            StreamBuilder(
                stream: StoreToFireStore().getNotes(reference: notesReference),
                builder: (context, AsyncSnapshot<QuerySnapshot> snaps) {
                  if (snaps.hasError) {
                    return Center(
                      child: Text('Any Error'),
                    );
                  } else {
                    if (snaps.data != null) {
                      var data = snaps.data?.docs.reversed.toList();
                      // print(data);
                      return Expanded(
                        // height: s.height * 0.6,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: s.width * 0.06,
                                    mainAxisSpacing: s.width * 0.06,
                                    childAspectRatio: 3 / 4),
                            padding: EdgeInsets.only(
                                left: s.width * 0.05,
                                right: s.width * 0.05,
                                top: s.width * 0.05,
                                bottom: s.width * 0.05),
                            itemCount: data!.length,
                            itemBuilder: (context, i) {
                              return Container(
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(data[i].id,
                                              style: theme.textTheme.headline5),
                                          Divider(),
                                          Container(
                                            child: Text(
                                              data[i]['note'],
                                              style: theme.textTheme.bodyText2,
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 7,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Divider(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: RaisedButton(
                                                onPressed: () async {
                                                  var bm = await checkBiometric(
                                                      biometric: data[i]
                                                          ['biometric']);
                                                  if (bm) {
                                                    await showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return EditNoteDialog(
                                                            reference:
                                                                notesReference
                                                                    .doc(data[i]
                                                                        .id),
                                                            title: data[i]
                                                                ['title'],
                                                            note: data[i]
                                                                ['note'],
                                                          );
                                                        });
                                                  }
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.blue,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                child: RaisedButton(
                                                    onPressed: () async {
                                                      var bm =
                                                          await checkBiometric(
                                                              biometric: data[i]
                                                                  [
                                                                  'biometric']);
                                                      if (bm) {
                                                        await StoreToFireStore()
                                                            .deleteDoc(context: context,
                                                                reference:
                                                                    notesReference
                                                                        .doc(data[i]
                                                                            .id));
                                                      }
                                                    },
                                                    child: Icon(
                                                      Icons.delete,
                                                      color: Colors.red,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))))),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    // color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12,
                                        offset: Offset(0, 2),
                                      )
                                    ]),
                                // height: s.height * 0.15,
                              );
                            }),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }
                }),
          if (curIndex == 2)
            StreamBuilder(
                stream: StoreToFireStore().getFolders(storeReference),
                builder: (context, AsyncSnapshot<QuerySnapshot> snaps) {
                  if (snaps.hasError) {
                    return Center(
                      child: Text('Any Error'),
                    );
                  } else {
                    if (snaps.data != null) {
                      var data = snaps.data?.docs.reversed.toList();
                      // print(data);
                      return Expanded(
                        // height: s.height * 0.6,
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: s.width * 0.06,
                                    mainAxisSpacing: s.width * 0.06),
                            padding: EdgeInsets.only(
                                left: s.width * 0.05,
                                right: s.width * 0.05,
                                top: s.width * 0.05,
                                bottom: s.width * 0.05),
                            itemCount: data!.length,
                            itemBuilder: (context, i) {
                              return buildStoreCards(theme, s,context: context,
                                  reference: storeReference.doc(data[i].id),
                                  title: data[i].id,
                                  biometric: data[i]['biometric'],
                                  image: data[i]['image'], onTap: () async {
                                var boole = await checkBiometric(
                                    biometric: data[i]['biometric']);
                                if (boole) {
                                  await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return ViewStoreDialog(
                                            id: data[i].id,
                                            about: data[i]['about'],
                                            reference: storeReference,
                                            image: data[i]['image']);
                                      });
                                }
                              });
                            }),
                      );
                    } else {
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
}

Future<bool> checkBiometric({
  required bool biometric,
}) async {
  bool result = false;
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
            result = true;
          } else {
            Fluttertoast.showToast(msg: 'Could\'nt authenticate.');
            result = false;
          }
        } on PlatformException catch (e) {
          print(e);
          Fluttertoast.showToast(msg: e.message!);
          // ...
        }
      }
    }
  } else {
    result = true;
  }
  return result;
}

InkWell buildFolderCards(ThemeData theme, Size s,
    {required String title,
    required String image,
    required bool biometric,required BuildContext context,
    required VoidCallback onTap,
    required DocumentReference reference}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
              child: Text(
                title,
                style: theme.textTheme.headline6,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () async {
                      var bm = await checkBiometric(biometric: biometric);
                      if (bm) {
                        await StoreToFireStore()
                            .deleteDoc(reference: reference,context: context);
                      }
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    )),
                Container(
                  height: 35, width: 35,
                  // width: 70,
                  margin: EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover)),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

InkWell buildStoreCards(ThemeData theme, Size s,
    {required String title,required BuildContext context,
    required String image,
    required VoidCallback onTap,
    required bool biometric,
    required DocumentReference reference}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 25,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                )),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: theme.textTheme.headline6!
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5),
                    child: IconButton(
                        onPressed: () async {
                          var bm = await checkBiometric(biometric: biometric);
                          if (bm) {
                            await StoreToFireStore()
                                .deleteDoc(reference: reference,context: context);
                          }
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
