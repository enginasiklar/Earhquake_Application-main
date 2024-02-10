import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../main_home_view.dart';
import 'auth_method.dart';
import 'err_page_view.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  static String title = "/login";

  static String _logoPath = "assets/images/earth.png";

  @override
  Widget build(BuildContext context) {
    if (auth.currentUser != null) {
      return RootPage(
        userName: auth.currentUser!.displayName!,
      );
    }
    if (kIsWeb) {
      _logoPath = "images/earth.png";
    }
    return Scaffold(
      backgroundColor: Colors.blue.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              _logoPath,
              width: MediaQuery.of(context).size.shortestSide * 0.33,
              height: MediaQuery.of(context).size.shortestSide * 0.35,
            ),
            const SizedBox(
              height: 50,
            ),
            const Text(
              "Google Login",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.green.shade100),
                shape: const MaterialStatePropertyAll(
                  CircleBorder(),
                ),
              ),
              onPressed: () async {
                await AuthMethod.signInWithGoogle().then((value) {
                  if (value != null) {
                    Navigator.popAndPushNamed(
                      context,
                      MainHomeView.title,
                    );
                  } else {
                    Navigator.popAndPushNamed(context, ErrPageView.title);
                  }
                });
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(
                  Icons.g_mobiledata_rounded,
                  size: 50,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
