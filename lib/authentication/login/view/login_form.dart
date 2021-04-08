import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class LoginForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.verification != current.verification,
      builder: (_, state) {
        if (state.verification.isEmpty) {
          return _PhoneNumberForm();
        }

        return _OTPForm();
      },
    );
  }
}

class _PhoneNumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                  content: Text(
                'שגיאה, אמת/י המידע שהזנת ונסה/י שנית.',
              )),
            );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const AppCover(),
          _PhoneNumberInput(),
          const _SendOTPButton(),
        ],
      ),
    );
  }
}

class _PhoneNumberInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) =>
          previous.phoneNumberInput != current.phoneNumberInput,
      builder: (_, state) {
        final initialValue =
            state.phoneNumberInput.pure ? '05' : state.phoneNumberInput.value;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            initialValue: initialValue,
            key: const Key('PhoneNumberForm__PhoneNumberInput_TextField'),
            keyboardType: TextInputType.phone,
            textAlign: TextAlign.end,
            autofocus: true,
            maxLength: 10,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (phoneNumber) =>
                context.read<LoginCubit>().phoneNumberChanged(phoneNumber),
            onEditingComplete: state.status.isValidated
                ? () => context.read<LoginCubit>().sendOTP()
                : null,
            decoration: InputDecoration(
              labelText: 'מספר טלפון',
              errorText: state.phoneNumberInput.invalid
                  ? 'ספרות בלבד, ללא מקפים או רווחים'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _SendOTPButton extends StatelessWidget {
  const _SendOTPButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: const Text('המשך'),
          onPressed: state.status.isValidated
              ? () => context.read<LoginCubit>().sendOTP()
              : null,
        );
      },
    );
  }
}

class _OTPForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous != current,
      listener: (_, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text('שגיאה, אמת/י המידע שהזנת ונסה/י שנית.'),
              ),
            );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const AppCover(),
          _OTPInput(),
          _ConfirmPhoneNumberButton(),
          const _ClearVerificationIdButton(),
        ],
      ),
    );
  }
}

class _ClearVerificationIdButton extends StatelessWidget {
  const _ClearVerificationIdButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.read<LoginCubit>().clearVerification(),
      child: const Text('אם לא קיבלת SMS מאיתנו, לחצ/י כאן.'),
    );
  }
}

class _OTPInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.otpInput != current.otpInput,
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TextFormField(
            initialValue: state.otpInput.value,
            key: const Key('LoginForm__LoginInput_TextField'),
            keyboardType: TextInputType.number,
            autofocus: true,
            onChanged: (otp) => context.read<LoginCubit>().otpChanged(otp),
            decoration: InputDecoration(
              labelText: 'קוד אימות',
              errorText: state.otpInput.invalid ? 'קוד אימות לא תקין' : null,
            ),
            textAlign: TextAlign.end,
            maxLength: 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onEditingComplete: state.status.isValidated
                ? () => context.read<LoginCubit>().confirmPhoneNumber()
                : null,
          ),
        );
      },
    );
  }
}

class _ConfirmPhoneNumberButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: const Text('המשך'),
          onPressed: state.status.isValidated
              ? () => context.read<LoginCubit>().confirmPhoneNumber()
              : null,
        );
      },
    );
  }
}
