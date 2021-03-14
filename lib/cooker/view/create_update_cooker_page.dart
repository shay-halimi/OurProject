import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/media/media.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:location_services/location_services.dart';
import 'package:provider/provider.dart';

class CreateUpdateCookerPage extends StatelessWidget {
  const CreateUpdateCookerPage({
    Key key,
    @required this.cooker,
    @required this.isUpdating,
  }) : super(key: key);

  final Cooker cooker;
  final bool isUpdating;

  static Route route({@required Cooker cooker, @required bool isUpdating}) {
    return MaterialPageRoute<void>(
      builder: (_) =>
          CreateUpdateCookerPage(cooker: cooker, isUpdating: isUpdating),
    );
  }

  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CookerFormCubit(
        cooker: cooker,
        cookerBloc: context.read<CookerBloc>(),
        locationServices: context.read<LocationServices>(),
      ),
      child: CookerForm(
        isUpdating: isUpdating,
        cooker: cooker,
      ),
    );
  }
}

class CookerForm extends StatelessWidget {
  const CookerForm({
    Key key,
    @required this.isUpdating,
    @required this.cooker,
  }) : super(key: key);

  final bool isUpdating;
  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(isUpdating ? 'עריכת חשבון' : 'יצירת חשבון'),
      ),
      body: BlocListener<CookerFormCubit, CookerFormState>(
        listener: (context, state) {
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(const SnackBar(
                  content: Text('שגיאה, אמת.י המידע שהזנת ונסה.י שנית.')));
          }

          if (state.status.isSubmissionSuccess) {
            if (isUpdating) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                    const SnackBar(content: Text('חשבונך עודכן בהצלחה')));

              Navigator.of(context).pop();
            }
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const _PhotoURLInput(),
              const _DisplayNameInput(),
              const _AddressInput(),
              _SubmitButton(
                isUpdating: isUpdating,
              ),
            ],
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
      child: BlocBuilder<CookerFormCubit, CookerFormState>(
        buildWhen: (previous, current) =>
            previous.addressInput != current.addressInput,
        builder: (context, state) {
          return TextFormField(
            key: const Key('_AddressInput'),
            keyboardType: TextInputType.text,
            maxLines: 1,
            onChanged: (value) =>
                context.read<CookerFormCubit>().changeAddressName(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide:
                    const BorderSide(width: 1.0, style: BorderStyle.solid),
              ),
              labelText: 'כתובת',
              errorText: state.addressInput.invalid ? 'לא תקין' : null,
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
        return PhotoURLWidget(
          photoURL: state.photoURLInput.value,
          onPhotoURLChanged: (value) {
            context.read<CookerFormCubit>().changePhotoURL(value);
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    @required this.isUpdating,
  }) : super(key: key);

  final bool isUpdating;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookerFormCubit, CookerFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return CircularProgressIndicator();
        } else {
          return ElevatedButton(
            key: Key('CreateUpdatePointPage_SubmitButton_$isUpdating'),
            child: Text(isUpdating ? 'שמור' : 'המשך'),
            onPressed: state.status.isValidated
                ? () => isUpdating
                    ? context.read<CookerFormCubit>().update()
                    : context.read<CookerFormCubit>().create()
                : null,
          );
        }
      },
    );
  }
}
