import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

/// @TODO(Matan) marge with CookPage
class CreateUpdateCookPage extends StatelessWidget {
  const CreateUpdateCookPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/cooks/me/create'),
      builder: (_) => const CookMiddleware(
        child: CreateUpdateCookPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CookFormCubit(
        cookBloc: context.read<CookBloc>(),
        locationServices: context.read<LocationServices>(),
      ),
      child: const CookForm(),
    );
  }
}

class CookForm extends StatelessWidget {
  const CookForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cook = context.select((CookBloc bloc) => bloc.state.cook);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(cook.isEmpty
            ? S.of(context).createAccountPageTitle
            : S.of(context).updateAccountPageTitle),
      ),
      body: BlocListener<CookFormCubit, CookFormState>(
        listenWhen: (previous, current) => previous != current,
        listener: (_, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(S.of(context).error)));
          }

          if (state.status.isSubmissionSuccess) {
            if (cook.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                    content: Text(S.of(context).accountUpdatedSuccessfully)));

              Navigator.of(context).pop();
            }
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: _PhotoURLInput(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _DisplayNameInput(),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: _AddressInput(),
                  ),
                  Center(
                    child: _SubmitButton(
                      cook: cook,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressInput extends StatelessWidget {
  const _AddressInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookFormCubit, CookFormState>(
      buildWhen: (previous, current) =>
          previous.addressInput != current.addressInput,
      builder: (_, state) {
        return TextFormField(
          key: const Key('_AddressInput'),
          keyboardType: TextInputType.streetAddress,
          maxLines: 1,
          onChanged: (value) =>
              context.read<CookFormCubit>().changeAddressName(value),
          decoration: InputDecoration(
            labelText: S.of(context).address,
            errorText:
                state.addressInput.invalid ? S.of(context).invalid : null,
            helperText: S.of(context).addressHelperText,
          ),
          initialValue: state.addressInput.value.name,
        );
      },
    );
  }
}

class _DisplayNameInput extends StatelessWidget {
  const _DisplayNameInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookFormCubit, CookFormState>(
      buildWhen: (previous, current) =>
          previous.displayNameInput != current.displayNameInput,
      builder: (_, state) {
        return TextFormField(
          key: const Key('_DisplayNameInput'),
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: (value) =>
              context.read<CookFormCubit>().changeDisplayName(value),
          decoration: InputDecoration(
            labelText: S.of(context).displayName,
            errorText:
                state.displayNameInput.invalid ? S.of(context).invalid : null,
          ),
          initialValue: state.displayNameInput.value,
        );
      },
    );
  }
}

class _PhotoURLInput extends StatelessWidget {
  const _PhotoURLInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookFormCubit, CookFormState>(
      buildWhen: (previous, current) =>
          previous.photoURLInput != current.photoURLInput,
      builder: (_, state) {
        return PhotoURLWidget(
          photoURL: state.photoURLInput.value,
          onPhotoURLChanged: (value) {
            context.read<CookFormCubit>().changePhotoURL(value);
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    @required this.cook,
  }) : super(key: key);

  final Cook cook;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookFormCubit, CookFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(
              cook.isEmpty ? S.of(context).continueBtn : S.of(context).saveBtn),
          onPressed: state.status.isValidated
              ? () => context.read<CookFormCubit>().save()
              : null,
        );
      },
    );
  }
}
