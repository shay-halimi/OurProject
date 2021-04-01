import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class CreateUpdatePointPage extends StatelessWidget {
  const CreateUpdatePointPage({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static Route route({@required Point point}) {
    return MaterialPageRoute<void>(
      builder: (_) => CreateUpdatePointPage(point: point),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PointFormCubit(
        point: point,
        pointsBloc: context.read<PointsBloc>(),
      ),
      child: PointForm(
        point: point,
      ),
    );
  }
}

class PointForm extends StatelessWidget {
  const PointForm({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    final isPure =
        context.select((PointFormCubit cubit) => cubit.state.status.isPure);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          point.isEmpty ? 'פרסום מאכל' : 'עדכון ${point.title}',
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (isPure) return true;

          return showDialog<bool>(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text('האם לצאת?'),
                  content: const Text('האם לצאת בלי לשמור את השינויים?'),
                  actions: [
                    TextButton(
                      child: const Text('כן, צא בלי לשמור'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                    ElevatedButton(
                      child: const Text('לא'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                  ],
                );
              });
        },
        child: BlocListener<PointFormCubit, PointFormState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('שגיאה, אמת/י המידע שהזנת ונסה/י שנית.'),
                  ),
                );
            }

            if (state.status.isSubmissionSuccess) {
              Navigator.of(context).pop();
            }
          },
          child: SafeArea(
            child: ListView(
              children: [
                const _MediaInput(),
                ConstrainedBox(
                    constraints: const BoxConstraints(minHeight: 8.0)),
                const _TitleInput(),
                const _DescriptionInput(),
                const _PriceInput(),
                const _TagsInput(),
                _SubmitButton(point: point),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointFormCubit, PointFormState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return AppButton(
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(point.isEmpty ? 'פרסם' : 'עדכן'),
          onPressed: state.status.isValidated
              ? () => context.read<PointFormCubit>().save()
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Row(
            children: [
              for (var tag in Point.defaultTags)
                InputChip(
                  label: Text(tag),
                  onSelected: (selected) =>
                      context.read<PointFormCubit>().toggleTag(tag),
                  selected: state.tagsInput.value.contains(tag),
                ),
            ],
          );
        },
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
              labelText: 'מחיר',
              errorText: state.priceInput.invalid ? 'לא תקין' : null,
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
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: TextFormField(
            key: const Key('_DescriptionInput'),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLength: 1000,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeDescription(value),
            decoration: InputDecoration(
              labelText: 'תיאור',
              errorText: state.descriptionInput.invalid ? 'לא תקין' : null,
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
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) =>
            previous.titleInput != current.titleInput,
        builder: (context, state) {
          return TextFormField(
            key: const Key('_TitleInput'),
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: 60,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeTitle(value),
            decoration: InputDecoration(
              labelText: 'שם המאכל',
              errorText: state.titleInput.invalid ? 'לא תקין' : null,
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
    return BlocBuilder<PointFormCubit, PointFormState>(
      buildWhen: (previous, current) =>
          previous.mediaInput != current.mediaInput,
      builder: (_, state) {
        return MediaDialog(
          media: state.mediaInput.value,
          onMediaChanged: (value) =>
              context.read<PointFormCubit>().changeMedia(value),
        );
      },
    );
  }
}
