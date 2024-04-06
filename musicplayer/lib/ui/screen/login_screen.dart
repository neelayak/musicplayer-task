import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:musicplayer/provider/login_viewmodel.dart';
import 'package:musicplayer/ui/screen/list_screen.dart';
import 'package:musicplayer/ui/widget/introwidget.dart';
import 'package:provider/provider.dart';

import '../widget/custom_route.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(data.name)) {
      //   return 'User not exists';
      // }
      // if (mockUsers[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(name)) {
      //   return 'User not exists';
      // }
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(),
      child: Builder(builder: (context) {
        var loginVM = Provider.of<LoginViewModel>(context, listen: false);

        return FlutterLogin(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          navigateBackAfterRecovery: true,
          title: '',
          //onConfirmRecover: _signupConfirm,
          // onConfirmSignup: _signupConfirm,
          loginAfterSignUp: false,
          // additionalSignupFields: [
          //   const UserFormField(
          //     keyName: 'Username',
          //     icon: Icon(FontAwesomeIcons.userLarge),
          //   ),
          //   const UserFormField(keyName: 'Name'),
          //   const UserFormField(
          //       keyName: 'Su'
          //           'name'),
          //   UserFormField(
          //     keyName: 'phone_number',
          //     displayName: 'Phone Number',
          //     userType: LoginUserType.phone,
          //     fieldValidator: (value) {
          //       final phoneRegExp = RegExp(
          //         '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$',
          //       );
          //       if (value != null &&
          //           value.length < 7 &&
          //           !phoneRegExp.hasMatch(value)) {
          //         return "This isn't a valid phone number";
          //       }
          //       return null;
          //     },
          //   ),
          // ],
          userValidator: (value) {
            if (!value!.contains('@') || !value.endsWith('.com')) {
              return "Email must contain '@' and end with '.com'";
            }
            return null;
          },
          passwordValidator: (value) {
            if (value!.isEmpty) {
              return 'Password is empty';
            }
            return null;
          },
          onLogin: (loginData) {
            loginVM.logindata(loginData.name, loginData.password);
            debugPrint('Login info');
            debugPrint('Name: ${loginData.name}');
            debugPrint('Password: ${loginData.password}');
            return _loginUser(loginData);
          },
          onSignup: (signupData) {
            debugPrint('Signup info');

            debugPrint('Name: ${signupData.name}');
            debugPrint('Password: ${signupData.password}');

            signupData.additionalSignupData?.forEach((key, value) {
              debugPrint('$key: $value');
            });

            return _signupUser(signupData);
          },
          onSubmitAnimationCompleted: () {
            Navigator.of(context).pushReplacement(
              FadePageRoute(
                builder: (context) => ListScreen(),
              ),
            );
          },
          onRecoverPassword: (name) {
            debugPrint('Recover password info');
            debugPrint('Name: $name');
            return _recoverPassword(name);
            // Show new password dialog
          },
          //headerWidget: const IntroWidget(),
        );
      }),
    );
  }
}
