import 'package:cookpoint/authentication/authentication.dart';
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
              const SnackBar(content: Text('שגיאה בתחברות')),
            );
        } else if (state.status.isSubmissionSuccess) {
          Navigator.of(context).push<void>(OTPPage.route());
        }
      },
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Icon(Icons.fastfood),
            _PhoneNumberInput(),
            _ContinueButton(),
          ],
        ),
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
          onChanged: (phoneNumber) =>
              context.read<PhoneNumberCubit>().phoneNumberChanged(phoneNumber),
          decoration: InputDecoration(
            labelText: 'מספר טלפון',
            helperText: '',
            errorText: state.phoneNumber.invalid ? 'מספר פלאפון לא תקין' : null,
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
