import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/media/media_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class CookerPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CookerPage());
  }

  @override
  Widget build(BuildContext context) {
    final cooker = context.select((CookerBloc bloc) => bloc.state.cooker);

    if (cooker.isEmpty) {
      return AuthenticationPage();
    }

    return BlocProvider(
      create: (_) => CookerFormCubit(
        cooker: cooker,
        cookersRepository: context.read<CookersRepository>(),
      ),
      child: CookerForm(cooker: cooker),
    );
  }
}

class CookerForm extends StatelessWidget {
  const CookerForm({
    Key key,
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('החשבון שלי'),
        actions: [
          BlocBuilder<CookerFormCubit, CookerFormState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              if (state.status.isValidated &&
                  !state.status.isSubmissionSuccess) {
                return IconButton(
                  key: const Key('CookerForm_ElevatedButton_Update'),
                  icon: state.status.isSubmissionInProgress
                      ? const CircularProgressIndicator()
                      : const Icon(Icons.save),
                  onPressed: () => context.read<CookerFormCubit>().update(),
                  tooltip: 'שמור את השינויים שעשית בחשבונך',
                );
              }

              return Container();
            },
          ),
        ],
      ),
      body: BlocListener<CookerFormCubit, CookerFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text(
                      'שגיאה בעדכון חשבונך, בדוק את המידע שהזנת ונסה שוב.')));
          }

          if (state.status.isSubmissionSuccess) {
            Scaffold.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  const SnackBar(content: Text('חשבונך עודכן בהצלחה')));
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _PhotoURLInput(),
              const _DisplayNameInput(),
            ],
          ),
        ),
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
      child: BlocBuilder<CookerFormCubit, CookerFormState>(
        buildWhen: (previous, current) =>
            previous.displayNameInput != current.displayNameInput,
        builder: (context, state) {
          return TextFormField(
            key: const Key('_DisplayNameInput'),
            keyboardType: TextInputType.text,
            maxLines: 1,
            onChanged: (value) =>
                context.read<CookerFormCubit>().changeDisplayName(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide:
                    const BorderSide(width: 1.0, style: BorderStyle.solid),
              ),
              labelText: 'שם לתצוגה',
              errorText: state.displayNameInput.invalid ? 'לא תקין' : null,
            ),
            initialValue: state.displayNameInput.value,
            onEditingComplete: () => context.read<CookerFormCubit>().update(),
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
    return BlocBuilder<CookerFormCubit, CookerFormState>(
      buildWhen: (previous, current) =>
          previous.photoURLInput != current.photoURLInput,
      builder: (_, state) {
        return MediaDialog(
          media: {state.photoURLInput.value},
          onMediaChanged: (value) {
            context.read<CookerFormCubit>().changePhotoURL(value.first);
            context.read<CookerFormCubit>().update();
          },
        );
      },
    );
  }
}
