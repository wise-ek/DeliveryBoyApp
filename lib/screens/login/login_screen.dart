// login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/login_provider.dart';

import '../../providers/order_provider.dart';
import '../home/home_screen.dart';
import 'widgets/logo_image.dart';
import 'widgets/otp_input_field.dart';
import 'widgets/phone_input_field.dart';
import 'widgets/send_otp_button.dart';
import 'widgets/verify_otp_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<LoginProvider>(context, listen: false).loadToken();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Consumer2<LoginProvider,OrderProvider>(
          builder: (context, provider,orderPro, _) {
            if (provider.token != null) {
              print(provider.uid+"kjkjk");

              orderPro.listenToOrders(provider.uid);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(

                    builder: (_) => HomeScreen(
                      name: provider.name,
                      phoneNumber: provider.phoneNumber,
                      uid: provider.uid,
                    ),
                  ),
                );
                provider.clearTokenAfterNavigation();
              });
            }

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                     LogoImage(path:  'assets/Login page.png',),
                    const SizedBox(height: 30),
                    const Text(
                      "Login with Phone",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Get started by verifying your number",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),
                    PhoneInputField(controller: _phoneController, errorText: provider.errorMessage, showError: !provider.isOtpSent),
                    const SizedBox(height: 16),
                    if (!provider.isOtpSent)
                      SendOtpButton(
                        isLoading: provider.isLoading,
                        onPressed: () => provider.updatePhoneNumber(_phoneController.text.trim()),
                      ),
                    if (provider.isOtpSent) ...[
                      const SizedBox(height: 16),
                      const OtpInputField(),
                      const SizedBox(height: 16),
                      const VerifyOtpButton(),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}