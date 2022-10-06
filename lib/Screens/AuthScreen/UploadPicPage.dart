import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animator/animation/animator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hey_legend/DB/userInitialization.dart';
import 'package:hey_legend/Model/UserModel.dart';
import 'package:hey_legend/Screens/DashBoard/HomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_circular_progress_bar/simple_circular_progress_bar.dart';

import '../../Widgets/faseInRoute.dart';
import '../../sharedPreferenceConstants.dart';

class UploadProfilePicPage extends StatefulWidget {
  const UploadProfilePicPage({Key? key}) : super(key: key);

  @override
  State<UploadProfilePicPage> createState() => _UploadProfilePicPageState();
}

class _UploadProfilePicPageState extends State<UploadProfilePicPage>
    with SingleTickerProviderStateMixin {
  late String uid;
  var image = '';
  bool networkImage = false;
  bool uploading = false;

  ValueNotifier<double> valueNotifier = ValueNotifier(0.0);
  bool sizedBoxHeight = false;
  // late  AnimationController animationController;


  void getUser() async {
    var prefs = await SharedPreferences.getInstance();
    var user = UserModel.fromJson(jsonDecode(prefs.getString(userInfo)!));

    uid = user.uid!;
    print('User uid ----------------------------- $uid');
    // print(user);
  }

  void pickImage() async {
    var file = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (file != null) {
      setState(() {
        image = file.path;
        uploading = true;
      });
      Timer.periodic(const Duration(milliseconds: 25), (timer) {
        if (valueNotifier.value < 100) {
          setState(() {
            valueNotifier.value++;
            // print(valueNotifier.value);
          });
        }
      });
      var url = await UserInitialization()
          .uploadImageAndGetUrl(uid: uid, file: file.path);
      if (url != null) {

        var prefs = await SharedPreferences.getInstance();
        await prefs.setString(profilePic, url);
        print(url);
        setState(() {
          networkImage = false;
          uploading = false;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
    valueNotifier = ValueNotifier(0.0);

    Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      // setState(() {
      //   sizedBoxHeight = !sizedBoxHeight;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    var s = MediaQuery.of(context).size;
    var theme = Theme.of(context);
    // print(valueNotifier.value);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 246, 253, 0.9),
      body: Stack(
        children: [
          SizedBox(
            height: s.height,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: s.height * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choose a beautiful profile pic',
                      style: theme.textTheme.headline6,
                    ),
                  ],
                ),
                SizedBox(height: s.height * 0.05),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        pickImage();
                      },
                      child: Stack(
                        children: [
                          Opacity(
                            opacity: valueNotifier.value / 100,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage: image == ''
                                  ? const AssetImage('assets/onBoarding/3.png')
                                  : FileImage(
                                      File(image),
                                    ) as ImageProvider,
                            ),
                          ),
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: SimpleCircularProgressBar(
                              progressStrokeWidth: 10,
                              backStrokeWidth: 10,
                              progressColors: const [
                                Colors.cyan,
                                Colors.green,
                                Colors.amberAccent,
                                Colors.redAccent,
                                Colors.purpleAccent
                              ],
                              backColor: Colors.blueGrey,
                              valueNotifier: valueNotifier,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 80,
                  // color: Colors.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.white,
                      ),
                      AnimatedSize(
                        vsync: this,
                        duration: const Duration(seconds: 1),
                        reverseDuration: const Duration(seconds: 1),
                        curve: Curves.easeIn,
                        child: SizedBox(height: sizedBoxHeight ? 20 : 10),
                      ),
                      Container(
                        width: 100,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: const Center(child: Text('Select a photo.')),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: s.height * 0.05),
              ],
            ),
          ),
          /*

 */
          if (valueNotifier.value==100)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: s.height * 0.5,
                    child: Stack(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              height: s.height * 0.4,
                              width: s.width * 0.8,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        children: [
                                          SizedBox(height: s.height * 0.05),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Your profile pic has uploaded 👏',
                                                style: theme
                                                    .textTheme.headline6!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: s.height * 0.05),
                                          Card(
                                            color: const Color.fromRGBO(
                                                243, 246, 253, 0.6),
                                            child: Container(
                                              height: 100,
                                              width: 100,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: RaisedButton(
                                              onPressed: () {
                                                Get.offAll(HomePage());
                                                // Navigator.pushReplacement(
                                                //   context,
                                                //   ThisIsFadeRoute(
                                                //     route: const HomePage(),
                                                //   ),
                                                // );
                                              },
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              color: const Color(0x81F8479F),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 38.0,
                                                        vertical: 10),
                                                child: Text(
                                                  'Enter to your world!',
                                                  style:
                                                      theme.textTheme.headline6,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 50,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: theme.cardColor,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${(valueNotifier.value).toInt()} %',
                                style: theme.textTheme.headline5!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
