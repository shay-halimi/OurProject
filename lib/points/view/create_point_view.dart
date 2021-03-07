import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/media/media_dialog.dart';
import 'package:cookpoint/media/media_dialog_cubit.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class CreatePointForm extends StatelessWidget {
  const CreatePointForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreatePointFormCubit, CreatePointFormState>(
      listener: (context, state) {
        if (state.status.isSubmissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(
                content: Text(
                  'שגיאה ביציאת נקודת בישול, בדוק את המידע שהזנת ונסה שנית',
                ),
              ),
            );
        }

        if (state.status.isSubmissionSuccess) {
          Navigator.of(context).pop();
        }
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            const _MediaInput(),
            const _TitleInput(),
            const _DescriptionInput(),
            const _PriceInput(),
            const _LocationInput(),
            const _TagsInput(),
            const _ContinueButton(),
          ],
        ),
      ),
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePointFormCubit, CreatePointFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('_ContinueButton'),
                child: const Text('פרסם!'),
                onPressed: state.status.isValidated
                    ? () => context.read<CreatePointFormCubit>().submit()
                    : null,
              );
      },
    );
  }
}

class _TagsInput extends StatelessWidget {
  const _TagsInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var _tag in ['טבעוני', 'צמחוני'])
          BlocBuilder<CreatePointFormCubit, CreatePointFormState>(
            buildWhen: (previous, current) => previous != current,
            builder: (context, state) {
              return InputChip(
                label: Text(_tag),
                onSelected: (selected) =>
                    context.read<CreatePointFormCubit>().tagToggled(_tag),
                selected: state.tagsInput.value.contains(_tag),
              );
            },
          ),
      ],
    );
  }
}

class _LocationInput extends StatelessWidget {
  const _LocationInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final location = context.select((LocationCubit bloc) => bloc.state.current);

    context.read<CreatePointFormCubit>().locationChanged(
          location.latitude,
          location.longitude,
        );

    return Container();
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePointFormCubit, CreatePointFormState>(
      buildWhen: (previous, current) =>
          previous.priceInput != current.priceInput,
      builder: (context, state) {
        return TextField(
          key: const Key('_PriceInput'),
          keyboardType: TextInputType.text,
          maxLines: null,
          onChanged: (value) =>
              context.read<CreatePointFormCubit>().priceChanged(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
                  const BorderSide(width: 1.0, style: BorderStyle.solid),
            ),
            labelText: 'מחיר',
            errorText: state.priceInput.invalid ? 'מחיר לא תקין' : null,
          ),
        );
      },
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePointFormCubit, CreatePointFormState>(
      buildWhen: (previous, current) =>
          previous.descriptionInput != current.descriptionInput,
      builder: (context, state) {
        return TextField(
          key: const Key('_DescriptionInput'),
          keyboardType: TextInputType.text,
          maxLines: null,
          onChanged: (value) =>
              context.read<CreatePointFormCubit>().descriptionChanged(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
                  const BorderSide(width: 1.0, style: BorderStyle.solid),
            ),
            labelText: 'תיאור',
            errorText: state.descriptionInput.invalid ? 'תיאור לא תקין' : null,
          ),
        );
      },
    );
  }
}

class _TitleInput extends StatelessWidget {
  const _TitleInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreatePointFormCubit, CreatePointFormState>(
      buildWhen: (previous, current) =>
          previous.titleInput != current.titleInput,
      builder: (context, state) {
        return TextField(
          key: const Key('_TitleInput'),
          keyboardType: TextInputType.text,
          maxLines: 1,
          onChanged: (value) =>
              context.read<CreatePointFormCubit>().titleChanged(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(4.0),
              borderSide:
                  const BorderSide(width: 1.0, style: BorderStyle.solid),
            ),
            labelText: 'שם המאכל',
            errorText: state.titleInput.invalid ? 'שם המאכל לא תקין' : null,
          ),
        );
      },
    );
  }
}

class _MediaInput extends StatelessWidget {
  const _MediaInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MediaDialogCubit(),
      child: MediaDialog(
        onMediaCreated: (media) =>
            context.read<CreatePointFormCubit>().mediaChanged({media}),
      ),
    );
  }
}
