import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_legend/Screens/AuthScreen/LoginScreens.dart';
import 'package:hey_legend/Widgets/faseInRoute.dart';

class OnBoarding1 extends StatelessWidget {
  const OnBoarding1({Key? key}) : super(key: key);
  static const String route = '/onBoarding1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlueAccent,
                  Colors.white70.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Image.asset('assets/onBoarding/1.png'),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              // color: Colors.red,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Access Anywhere',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      r'C:\src\flutter\bin\flutter.bat --no-color pub get  Running "flutter pub get" in hey_legend...                          5.6s  Process finished with exit code 0r',
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 5,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context, ThisIsFadeRoute(route: OnBoarding2()));
                    },
                    child: Text('Go to next'),
                  ),
                  Container(
                    height: 10,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoarding2 extends StatelessWidget {
  const OnBoarding2({Key? key}) : super(key: key);
  static const String route = '/onBoarding2';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlueAccent,
                  Colors.white70.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Image.asset('assets/onBoarding/2.png'),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              // color: Colors.red,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Control Your Finance',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      r'C:\src\flutter\bin\flutter.bat --no-color pub get  Running "flutter pub get" in hey_legend...                          5.6s  Process finished with exit code 0r',
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 5,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context, ThisIsFadeRoute(route: OnBoarding3()));
                    },
                    child: const Text('Go to next'),
                  ),
                  Container(
                    height: 10,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoarding3 extends StatelessWidget {
  const OnBoarding3({Key? key}) : super(key: key);
  static const String route = '/onBoarding3';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightBlueAccent,
                  Colors.white70.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                ),
                Image.asset('assets/onBoarding/3.png'),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            child: SizedBox(
              // color: Colors.red,
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Increase Your Savings',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.75,
                    child: Text(
                      r'C:\src\flutter\bin\flutter.bat --no-color pub get  Running "flutter pub get" in hey_legend...                          5.6s  Process finished with exit code 0r',
                      style: Theme.of(context).textTheme.bodyText1,
                      maxLines: 5,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    onPressed: () {
                      Get.offAllNamed(LoginScreen.route);
                    },
                    child: const Text('Get Started'),
                  ),
                  Container(
                    height: 10,
                    width: 30,
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
