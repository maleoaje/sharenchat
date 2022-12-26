import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sharenchat/constants/app_constants.dart';
import 'package:sharenchat/providers/auth_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'pages.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in failed");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in successful");
        break;
      default:
        break;
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text(
            AppConstants.loginTitle,
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to Share n Chat!',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 90),
                    child: Center(
                      child: TextButton(
                        onPressed: () async {
                          authProvider.handleSignIn().then((isSuccess) {
                            if (isSuccess) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              );
                            }
                          }).catchError((error, stackTrace) {
                            Fluttertoast.showToast(msg: error.toString());
                            authProvider.handleException();
                            log(error.toString());
                            log(stackTrace.toString());
                          });
                        },
                        style: ButtonStyle(
                          elevation: MaterialStateProperty.all(2),
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 206, 203, 203)
                                    .withOpacity(0.8);
                              }
                              return const Color.fromARGB(255, 255, 255, 255);
                            },
                          ),
                          splashFactory: NoSplash.splashFactory,
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(20, 15, 20, 15),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Text(
                              'Sign in with Google',
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Image.asset(
                              'images/google.png',
                              width: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Loading
            Positioned(
              child: authProvider.status == Status.authenticating
                  ? const LoadingView()
                  : const SizedBox.shrink(),
            ),
          ],
        ));
  }
}
