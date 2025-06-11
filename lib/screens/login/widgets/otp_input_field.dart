import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import '../../../../../providers/login_provider.dart';

class OtpInputField extends StatelessWidget {
  const OtpInputField({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<LoginProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PinCodeTextField(
          length: 6,
          appContext: context,
          onChanged: provider.updateOtp,
          keyboardType: TextInputType.number,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: BorderRadius.circular(8),
            fieldHeight: 50,
            fieldWidth: 40,
            activeColor: Colors.deepOrange,
            selectedColor: Colors.orange,
            inactiveColor: Colors.grey.shade300,
          ),
          textStyle: const TextStyle(fontSize: 20),
          cursorColor: Colors.deepOrange,
          autoDismissKeyboard: true,
        ),
        if (provider.errorMessage.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 8),
            child: Text(
              provider.errorMessage,
              style: const TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
}
