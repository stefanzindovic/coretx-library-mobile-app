import 'package:cortex_library_mobile_app/theme/palette.dart';
import 'package:cortex_library_mobile_app/features/login/ui/login_screen.dart';
import 'package:cortex_library_mobile_app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<String?> _authToken;

  Future<String?> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();

    final String? token = prefs.getString('auth_token');

    return token;
  }

  @override
  void initState() {
    super.initState();
    _authToken = getAuthToken();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (context, child) {
          return MaterialApp(
            theme: data,
            home: FutureBuilder(
              future: _authToken,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Scaffold(
                      backgroundColor: backgroundColor,
                      body: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  case ConnectionState.done:
                  default:
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      return HomeScreen(authToken: snapshot.data!);
                    } else {
                      return const LoginScreen();
                    }
                }
              },
            ),
          );
        });
  }
}
