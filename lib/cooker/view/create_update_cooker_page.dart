import 'package:cookers_repository/cookers_repository.dart';
import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:location_services/location_services.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CreateUpdateCookerPage extends StatelessWidget {
  const CreateUpdateCookerPage({
    Key key,
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  static Route route({@required Cooker cooker}) {
    return MaterialPageRoute<void>(
      builder: (_) => CreateUpdateCookerPage(
        cooker: cooker,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              PointsBloc(pointsRepository: context.read<PointsRepository>())
                ..add(
                  PointsOfCookerRequestedEvent(
                    cooker.id,
                  ),
                ),
        ),
        BlocProvider(
          create: (context) => CookerFormCubit(
            pointsBloc: context.read<PointsBloc>(),
            cookerBloc: context.read<CookerBloc>(),
            locationServices: context.read<LocationServices>(),
          ),
        ),
      ],
      child: CookerForm(
        cooker: cooker,
      ),
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
        title: Text(cooker.isNotEmpty ? 'עדכון מטבח' : 'יצירת מטבח'),
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
            if (cooker.isNotEmpty) {
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
                    cooker: cooker,
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
      child: BlocBuilder<CookerFormCubit, CookerFormState>(
        buildWhen: (previous, current) =>
            previous.addressInput != current.addressInput,
        builder: (context, state) {
          return TextFormField(
            key: const Key('_AddressInput'),
            keyboardType: TextInputType.streetAddress,
            maxLines: 1,
            onChanged: (value) =>
                context.read<CookerFormCubit>().changeAddressName(value),
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
    @required this.cooker,
  }) : super(key: key);

  final Cooker cooker;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CookerFormCubit, CookerFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(cooker.isNotEmpty ? 'שמור' : 'המשך'),
          onPressed: state.status.isValidated
              ? () => context.read<CookerFormCubit>().save()
              : null,
        );
      },
    );
  }
}
