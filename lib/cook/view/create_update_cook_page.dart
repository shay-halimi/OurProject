import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:cooks_repository/cooks_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:location_services/location_services.dart';
import 'package:provider/provider.dart';

class CreateUpdateCookPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(
      builder: (_) => CookMiddleware(child: CreateUpdateCookPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CookFormCubit(
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
        title: Text(cook.isNotEmpty ? 'עדכון מטבח' : 'יצירת מטבח'),
      ),
      body: BlocListener<CookFormCubit, CookFormState>(
        listener: (context, state) {
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
                    const SnackBar(content: Text('המטבח עודכן בהצלחה')));

              Navigator.of(context).pop();
            }
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(child: _PhotoURLInput()),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 16),
                ),
                const _DisplayNameInput(),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 16),
                ),
                const _AddressInput(),
                ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 16),
                ),
                Center(
                  child: _SubmitButton(
                    cook: cook,
                  ),
                ),
              ],
            ),
          ),
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<CookFormCubit, CookFormState>(
        buildWhen: (previous, current) =>
            previous.addressInput != current.addressInput,
        builder: (context, state) {
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
      ),
    );
  }
}

class _DisplayNameInput extends StatelessWidget {
  const _DisplayNameInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<CookFormCubit, CookFormState>(
        buildWhen: (previous, current) =>
            previous.displayNameInput != current.displayNameInput,
        builder: (context, state) {
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
      ),
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
      builder: (context, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(cook.isNotEmpty ? 'שמור' : 'המשך'),
          onPressed: state.status.isValidated
              ? () => context.read<CookFormCubit>().save()
              : null,
        );
      },
    );
  }
}