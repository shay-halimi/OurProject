import 'package:cookpoint/media/media_dialog.dart';
import 'package:cookpoint/points/points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:points_repository/points_repository.dart';
import 'package:provider/provider.dart';

class CreateUpdatePointPage extends StatelessWidget {
  const CreateUpdatePointPage({Key key, @required this.point})
      : super(key: key);

  final Point point;

  static Route route({@required Point point}) {
    return MaterialPageRoute<void>(
        builder: (_) => CreateUpdatePointPage(point: point));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PointFormCubit(
        point: point,
        pointsRepository: context.read<PointsRepository>(),
      ),
      child: const PointForm(),
    );
  }
}

class PointForm extends StatelessWidget {
  const PointForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('הוספת נקודת בישול')),
      body: BlocListener<PointFormCubit, PointFormState>(
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
              const _TagsInput(),
            ],
          ),
        ),
      ),
      persistentFooterButtons: [const _ContinueButton()],
    );
  }
}

class _ContinueButton extends StatelessWidget {
  const _ContinueButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointFormCubit, PointFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        if (state.status.isSubmissionInProgress) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  key: const Key('_ContinueButton'),
                  child: const Text('פרסם!'),
                  onPressed: state.status.isValidated
                      ? () => context.read<PointFormCubit>().submit()
                      : null,
                ),
              ),
            ],
          );
        }
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          for (var _tag in ['טבעוני', 'צמחוני'])
            BlocBuilder<PointFormCubit, PointFormState>(
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return InputChip(
                  label: Text(_tag),
                  onSelected: (selected) =>
                      context.read<PointFormCubit>().toggledTag(_tag),
                  selected: state.tagsInput.value.contains(_tag),
                );
              },
            ),
        ],
      ),
    );
  }
}

class _PriceInput extends StatelessWidget {
  const _PriceInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) =>
            previous.priceInput != current.priceInput,
        builder: (context, state) {
          return TextFormField(
            key: const Key('_PriceInput'),
            keyboardType: TextInputType.number,
            maxLines: null,
            onChanged: (value) =>
                context.read<PointFormCubit>().changePrice(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide:
                    const BorderSide(width: 1.0, style: BorderStyle.solid),
              ),
              labelText: 'מחיר',
              errorText: state.priceInput.invalid ? 'מחיר לא תקין' : null,
              suffix: const Text('₪'),
            ),
            textAlign: TextAlign.end,
            initialValue: state.priceInput.value.isEmpty
                ? null
                : state.priceInput.value.amount.toStringAsFixed(2),
          );
        },
      ),
    );
  }
}

class _DescriptionInput extends StatelessWidget {
  const _DescriptionInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointFormCubit, PointFormState>(
      buildWhen: (previous, current) =>
          previous.descriptionInput != current.descriptionInput,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: const Key('_DescriptionInput'),
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 6,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeDescription(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide:
                    const BorderSide(width: 1.0, style: BorderStyle.solid),
              ),
              labelText: 'תיאור',
              errorText:
                  state.descriptionInput.invalid ? 'תיאור לא תקין' : null,
            ),
            initialValue: state.descriptionInput.value,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) =>
            previous.titleInput != current.titleInput,
        builder: (context, state) {
          return TextFormField(
            key: const Key('_TitleInput'),
            keyboardType: TextInputType.text,
            maxLines: 1,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeTitle(value),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide:
                    const BorderSide(width: 1.0, style: BorderStyle.solid),
              ),
              labelText: 'שם המאכל',
              errorText: state.titleInput.invalid ? 'שם המאכל לא תקין' : null,
            ),
            initialValue: state.titleInput.value,
          );
        },
      ),
    );
  }
}

class _MediaInput extends StatelessWidget {
  const _MediaInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(4.0)),
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) =>
            previous.mediaInput != current.mediaInput,
        builder: (_, state) {
          return MediaDialog(
            media: state.mediaInput.value,
            onMediaChanged: (value) =>
                context.read<PointFormCubit>().changeMedia(value),
          );
        },
      ),
    );
  }
}
