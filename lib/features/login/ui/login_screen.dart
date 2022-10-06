import 'dart:convert';

import 'package:cortex_library_mobile_app/features/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../theme/palette.dart';
import '../../../theme/textTheme.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 26.w),
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 128.h),
                  Text(
                    'Dobrodošli,',
                    style: displayTextStyle,
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Prijavite se da bi ste nastavili.',
                    style: bodyTextStyle,
                  ),
                  SizedBox(height: 48.h),
                  TextFormField(
                    controller: _usernameController,
                    validator: (value) {
                      if (value!.length < 3 || value!.length > 354) {
                        return 'Unesite validno korisničko ime.';
                      }
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    autocorrect: false,
                    cursorColor: primaryColor,
                    keyboardAppearance: Brightness.dark,
                    style: bodyTextStyle.copyWith(color: lightColor),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.at,
                        color: neutralColor,
                      ),
                      prefixIconColor: lightColor,
                      hintText: 'Korisničko ime',
                    ),
                  ),
                  SizedBox(height: 16.h),
                  TextFormField(
                    validator: (value) {
                      if (value!.length < 8) {
                        return 'Unesite validnu lozinku.';
                      }
                    },
                    controller: _passwordController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    obscureText: true,
                    autocorrect: false,
                    cursorColor: primaryColor,
                    keyboardAppearance: Brightness.dark,
                    style: bodyTextStyle.copyWith(color: lightColor),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        CupertinoIcons.lock_fill,
                        color: neutralColor,
                      ),
                      prefixIconColor: lightColor,
                      hintText: 'Lozinka',
                    ),
                  ),
                  SizedBox(height: 36.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var headers = {
                            'Content-Type': 'application/json',
                            'Accept': 'application/json',
                            'Authorization':
                                'Bearer b3Rvcmlub2xhcmluZ29sb2dpamE='
                          };
                          var request = http.Request('POST',
                              Uri.parse('https://www.intheloop.pro/api/login'));
                          request.body = jsonEncode({
                            "username": _usernameController.text,
                            "password": _passwordController.text,
                            "device": "DivajsNejm"
                          });
                          request.headers.addAll(headers);

                          http.StreamedResponse response = await request.send();

                          if (response.statusCode == 200) {
                            final prefs = await SharedPreferences.getInstance();
                            var data = await response.stream.bytesToString();
                            var decode = jsonDecode(data);
                            prefs
                                .setString(
                                    'auth_token', decode['data']['token'])
                                .then((value) {
                              value
                                  ? Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                        builder: (context) => HomeScreen(
                                          authToken: decode['data']['token'],
                                        ),
                                      ),
                                      (Route<dynamic> route) => false)
                                  : null;
                            });
                          } else {
                            print(response.reasonPhrase);
                          }
                        }
                      },
                      child: Text('Dalje'),
                    ),
                  ),
                  SizedBox(height: 36.h),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 128.w,
                      height: 2.h,
                      color: neutralColor,
                    ),
                  ),
                  SizedBox(height: 36.h),
                  // register link
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: RichText(
                      text: TextSpan(
                        text: 'Novi član? ',
                        style: bodyTextStyle,
                        children: [
                          TextSpan(
                            text: 'Učlanite se.',
                            style: buttonTextStyle.copyWith(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
