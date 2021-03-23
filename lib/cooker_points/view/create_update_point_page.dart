import 'package:cookpoint/cooker/cooker.dart';
import 'package:cookpoint/cooker_points/cooker_points.dart';
import 'package:cookpoint/media/media_dialog.dart';
import 'package:cookpoint/points/bloc/bloc.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:points_repository/points_repository.dart';
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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              PointsBloc(pointsRepository: context.read<PointsRepository>())
                ..add(
                  PointsOfCookerRequestedEvent(
                    point.cookerId,
                  ),
                ),
        ),
        BlocProvider(
          create: (context) => PointFormCubit(
            point: point,
            cookerBloc: context.read<CookerBloc>(),
            pointsBloc: context.read<PointsBloc>(),
          ),
        )
      ],
      child: PointForm(point: point),
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
          point.isNotEmpty ? 'עדכון ${point.title}' : 'הוספת מאכל',
        ),
        actions: [
          if (point.isNotEmpty)
            _DeleteButton(
              point: point,
            ),
        ],
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
                    content: Text('שגיאה, אמת.י המידע שהזנת ונסה.י שנית.'),
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
                const _AvailableInput(),
                _SubmitButton(
                  point: point,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.delete),
      tooltip: 'מחק',
      onPressed: () => showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('האם אתה בטוח?'),
              content:
                  Text('האם אתה בטוח שברצונך למחוק את המאכל ${point.title} ?'),
              actions: [
                TextButton(
                  child: const Text('כן, מחק לצמיתות'),
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
          }).then((value) {
        if (value != null && value) {
          context.read<PointsBloc>().add(PointDeletedEvent(point));
          Navigator.of(context).pop();
        }
      }),
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
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(point.isNotEmpty ? 'שמור' : 'פרסם!'),
          onPressed: state.status.isValidated
              ? () => context.read<PointFormCubit>().save()
              : null,
        );
      },
    );
  }
}

class _AvailableInput extends StatelessWidget {
  const _AvailableInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) =>
            previous.availableInput != current.availableInput,
        builder: (_, state) {
          return SwitchListTile(
            title: state.availableInput.value
                ? const Text('זמין')
                : const Text('לא זמין'),
            subtitle: const Text('מאכלים זמינים מופיעים על המפה עם'
                ' מספר הטלפון איתו נרשמתם.'),
            value: state.availableInput.value,
            onChanged: (bool value) {
              context.read<PointFormCubit>().changeAvailable(value);
            },
          );
        },
      ),
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
      child: BlocBuilder<PointFormCubit, PointFormState>(
        buildWhen: (previous, current) => previous != current,
        builder: (context, state) {
          return Row(
            children: [
              for (var tag in Point.defaultTags)
                InputChip(
                  label: Text(tag),
                  onSelected: (selected) =>
                      context.read<PointFormCubit>().toggledTag(tag),
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
            maxLength: 1000,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeDescription(value),
            decoration: InputDecoration(
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
            maxLength: 60,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeTitle(value),
            decoration: InputDecoration(
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
    return BlocBuilder<PointFormCubit, PointFormState>(
      buildWhen: (previous, current) =>
          previous.mediaInput != current.mediaInput,
      builder: (_, state) {
        return Container(
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              border: Border.all(
                  color: state.mediaInput.pure
                      ? theme.colorScheme.primary
                      : theme.colorScheme.surface),
              borderRadius: BorderRadius.circular(33.0)),
          child: MediaDialog(
            media: state.mediaInput.value,
            onMediaChanged: (value) =>
                context.read<PointFormCubit>().changeMedia(value),
          ),
        );
      },
    );
  }
}
