import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
              const SnackBar(
                content: Text(
                  'שגיאה באימות מספר הטלפון, בדוק את הקוד ששלחנו לך ונסה שוב',
                ),
              ),
            );
        }

        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const AppLogo(),
          _OTPInput(),
          _ContinueButton(),
        ],
      ),
    );
  }
}

class _OTPInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OTPCubit, OTPState>(
      buildWhen: (previous, current) => previous.otp != current.otp,
      builder: (context, state) {
        return TextField(
          key: const Key('OTPForm__OTPInput_TextField'),
          keyboardType: TextInputType.number,
          autofocus: true,
          onChanged: (otp) => context.read<OTPCubit>().otpChanged(otp),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
                  const BorderSide(width: 1.0, style: BorderStyle.solid),
            ),
            labelText: 'קוד האימות ששלחנו אלייך',
            errorText: state.otp.invalid ? 'קוד אימות לא תקין' : null,
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
                key: const Key('OTPForm__ContinueButton_ElevatedButton'),
                child: const Text('המשך'),
                onPressed: state.status.isValidated
                    ? () => context.read<OTPCubit>().confirmPhoneNumber()
                    : null,
              );
      },
    );
  }
}
