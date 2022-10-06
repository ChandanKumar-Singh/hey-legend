import 'package:flutter/material.dart';
import 'package:hey_legend/Screens/OnBoarding/OnBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const route = '/splash';
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String TAG = 'SplashScreen';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: size.height / 4
              ),
              Center(
                child: SizedBox(
                  width: 300,
                  height: 250,
                  child: Image.asset('assets/appIcon/appIcon.png'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100,
        child: Column(
          children: const [
            CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 20),
            Text(
              'Beta Version',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkLogin(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('uid');
    debugPrint("$TAG UserId : $userId");
    Future.delayed(
      const Duration(seconds: 2),
      () {
        if (userId == null) {
          Navigator.of(context).pushReplacementNamed(OnBoarding1.route);
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      },
    );
  }
}
