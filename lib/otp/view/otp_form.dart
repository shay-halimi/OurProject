import 'package:cookpoint/otp/otp.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class OTPForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OTPCubit, OTPState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('שגיאה בשליחת קוד אימות')),
            );
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Icon(Icons.fastfood),
            _OTPInput(),
            _ContinueButton(),
          ],
        ),
      ),
    );
  }
}

class _OTPInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OTPCubit, OTPState>(
      buildWhen: (previous, current) =>
          previous.oneTimePassword != current.oneTimePassword,
      builder: (context, state) {
        return TextField(
          key: const Key(
              'OTPForm__OTPInput_TextField'),
          onChanged: (password) => context
              .read<OTPCubit>()
              .oneTimePasswordChanged(password),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'קוד אימות',
            helperText: '',
            errorText: state.oneTimePassword.invalid
                ? 'קוד אימות לא תקין'
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
    return BlocBuilder<OTPCubit, OTPState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key(
                    'OTPForm__ContinueButton_ElevatedButton'),
                child: const Text('המשך'),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<OTPCubit>()
                        .confirmPhoneNumber()
                    : null,
              );
      },
    );
  }
}
