import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class TermsAndAgreement extends StatefulWidget {
  const TermsAndAgreement({super.key});

  @override
  State<TermsAndAgreement> createState() => _TermsAndAgreementState();
}

class _TermsAndAgreementState extends State<TermsAndAgreement> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double textFieldWidth = screenWidth - 70;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value ?? false;
            });
          },
        ),
        SizedBox(
          width: textFieldWidth - 45,
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelMedium,
              children: [
                const TextSpan(
                  text:
                      'By checking this box, I confirm that I am at least 18 years old to use SpendSmart in accordance with its ',
                ),
                TextSpan(
                  text: 'Terms of Service',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),

                TextSpan(text: ' and '),

                TextSpan(
                  text: 'Privacy Policy.',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
