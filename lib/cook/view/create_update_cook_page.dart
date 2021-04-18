import 'package:cookpoint/cook/cook.dart';
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
        title: Text(cook.isEmpty ? 'יצירת חשבון' : 'עדכון חשבון'),
      ),
      body: BlocListener<CookFormCubit, CookFormState>(
        listenWhen: (previous, current) => previous != current,
        listener: (_, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('שגיאה, אמת/י המידע שהזנת ונסה/י שנית.')));
          }

          if (state.status.isSubmissionSuccess) {
            if (cook.isNotEmpty) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('חשבונך עודכן בהצלחה')));

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
            labelText: 'כתובת',
            errorText: state.addressInput.invalid ? 'לא תקין' : null,
            helperText: 'שם יישוב, שם רחוב ומספר בית.',
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
            labelText: 'שם לתצוגה',
            errorText: state.displayNameInput.invalid ? 'לא תקין' : null,
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
          child: Text(cook.isEmpty ? 'המשך' : 'שמור'),
          onPressed: state.status.isValidated
              ? () => context.read<CookFormCubit>().save()
              : null,
        );
      },
    );
  }
}
