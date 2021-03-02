import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class PhoneNumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PhoneNumberCubit, PhoneNumberState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text(
                'שגיאה בשליחת מסרון, נסה שוב מאוחר יותר',
              )),
            );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).push<void>(OTPPage.route());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const AppLogo(),
          _PhoneNumberInput(),
          _ContinueButton(),
        ],
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberCubit, PhoneNumberState>(
      buildWhen: (previous, current) =>
          previous.phoneNumber != current.phoneNumber,
      builder: (context, state) {
        return TextField(
          key: const Key('PhoneNumberForm__PhoneNumberInput_TextField'),
          keyboardType: TextInputType.phone,
          autofocus: true,
          onChanged: (phoneNumber) =>
              context.read<PhoneNumberCubit>().phoneNumberChanged(phoneNumber),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
                  const BorderSide(width: 1.0, style: BorderStyle.solid),
            ),
            labelText: 'מספר הטלפון שלך',
            errorText: state.phoneNumber.invalid
                ? 'ספרות בלבד, ללא מקפים או רווחים'
                : null,
          ),
        );
      },
    );
  }
}

class _ContinueButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PhoneNumberCubit, PhoneNumberState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key:
                    const Key('PhoneNumberForm__ContinueButton_ElevatedButton'),
                child: const Text('המשך'),
                onPressed: state.status.isValidated
                    ? () => context.read<PhoneNumberCubit>().sendOTP()
                    : null,
              );
      },
    );
  }
}
