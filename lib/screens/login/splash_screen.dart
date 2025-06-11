import 'dart:async';
import 'package:boyapp/providers/login_provider.dart';
import 'package:boyapp/screens/login/widgets/logo_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/colors.dart';
import '../../../constants/navigation_helper.dart';
import '../../../providers/order_provider.dart';
import '../home/home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    await Future.delayed(const Duration(seconds: 3)); // Optional splash delay

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final name = prefs.getString('user_name') ?? 'User';
    final phone = prefs.getString('user_phone') ?? '';
    final uid = prefs.getString('user_uid') ?? '';

    if (token != null) {
      print(uid+"dkjndfk");
      context.read<OrderProvider>().listenToOrders(uid);

      NavigationHelper.replaceWith(
        context,
        HomeScreen(name: name, phoneNumber: phone, uid: uid),
      );
    } else {
      NavigationHelper.replaceWith(context, const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LogoImage(path:  'assets/applogo.png'),
            const SizedBox(height: 10),
            const Text(
              "Delivery Boy App",
              style: TextStyle(
                color: AppColors.splashTextColor,
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
