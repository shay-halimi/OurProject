import 'package:cookpoint/one_time_password/one_time_password.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

class OneTimePasswordForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<OneTimePasswordCubit, OneTimePasswordState>(
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
            _OneTimePasswordInput(),
            _ContinueButton(),
          ],
        ),
      ),
    );
  }
}

class _OneTimePasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OneTimePasswordCubit, OneTimePasswordState>(
      buildWhen: (previous, current) =>
          previous.oneTimePassword != current.oneTimePassword,
      builder: (context, state) {
        return TextField(
          key: const Key(
              'OneTimePasswordForm__OneTimePasswordInput_TextField'),
          onChanged: (password) => context
              .read<OneTimePasswordCubit>()
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
    return BlocBuilder<OneTimePasswordCubit, OneTimePasswordState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key(
                    'OneTimePasswordForm__ContinueButton_ElevatedButton'),
                child: const Text('המשך'),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<OneTimePasswordCubit>()
                        .confirmPhoneNumber()
                    : null,
              );
      },
    );
  }
}
