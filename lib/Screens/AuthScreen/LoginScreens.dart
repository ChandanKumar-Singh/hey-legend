import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hey_legend/Auth/AuthController.dart';
import 'package:hey_legend/DB/userInitialization.dart';
import 'package:hey_legend/Screens/AuthScreen/UploadPicPage.dart';
import 'package:hey_legend/Screens/DashBoard/HomePage.dart';

import '../../Widgets/faseInRoute.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut<AuthController>(() => AuthController());
  }
}

class LoginScreen extends GetView<AuthController> {
  LoginScreen({Key? key}) : super(key: key);
  static const String route = '/login';

  TextEditingController nameCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  AuthController controller = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: s.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Login',
                style: theme.textTheme.headline4!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              TextFormField(
                controller: nameCont,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: passCont,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const [
                  Text('Forgot Password?'),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      await controller
                          .loginFromEmail(
                              userName: nameCont.text, password: passCont.text)
                          .then(
                            (value) => Navigator.pushReplacement(
                              context,
                              ThisIsFadeRoute(
                                route: const HomePage(),
                              ),
                            ),
                          );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38.0),
                      child: Text('Sign IN'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegistrationScreen(),
                          ),
                        );
                      },
                      child: const Text('Don\'t have an account? Sign Up')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends GetView<AuthController> {
  RegistrationScreen({Key? key}) : super(key: key);
  static const String route = '/registration';

  TextEditingController nameCont = TextEditingController();
  TextEditingController contactCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController passCont = TextEditingController();
  TextEditingController confirmPassCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var s = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: s.width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Registration',
                style: theme.textTheme.headline4!
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              TextFormField(
                controller: nameCont,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: contactCont,
                decoration: const InputDecoration(labelText: 'Mobile Number'),
              ),
              TextFormField(
                controller: emailCont,
                decoration: const InputDecoration(labelText: 'Email Id'),
              ),
              TextFormField(
                controller: passCont,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
              TextFormField(
                controller: confirmPassCont,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  RaisedButton(
                    onPressed: () async {
                      await controller
                          .registrationFromEmail(
                              name: nameCont.text,
                              userName: emailCont.text,
                              contact: contactCont.text,
                              password: confirmPassCont.text)
                          .then(
                            (value) => Navigator.pushReplacement(
                              context,
                              ThisIsFadeRoute(
                                route: const UploadProfilePicPage(),
                              ),
                            ),
                          );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 38.0),
                      child: Text('Create Account'),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: const Text('Already have an account? Sign In')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
