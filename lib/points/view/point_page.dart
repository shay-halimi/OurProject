import 'package:cookpoint/cook/cook.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/legal/legal.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class PointPage extends StatelessWidget {
  const PointPage({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static Route route({@required Point point}) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(
        name: point.isEmpty ? '/points/create' : '/points/${point.id}/update',
      ),
      builder: (_) => CookMiddleware(
        child: CookTermsOfServiceMiddleware(
          child: PointPage(point: point),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PointFormCubit(
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
    final status = context.select((PointFormCubit cubit) => cubit.state.status);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          point.isEmpty
              ? S.of(context).createPointPageTitle
              : S.of(context).updatePointPageTitle,
        ),
        actions: [
          if (point.isNotEmpty && status.isValidated)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => context.read<PointFormCubit>().save(),
            ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: WillPopScope(
          onWillPop: () async {
            if (status.isPure) return true;

            return showDialog<bool>(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text(S.of(context).discardChangesAlertTitle),
                  actions: [
                    TextButton(
                      child: Text(S.of(context).saveBtn),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    ElevatedButton(
                      child: Text(S.of(context).discardBtn),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                );
              },
            ).then((discard) {
              if (!discard && status.isValidated) {
                context.read<PointFormCubit>().save();
                return true;
              }

              return discard;
            });
          },
          child: BlocListener<PointFormCubit, PointFormState>(
            listenWhen: (previous, current) => previous != current,
            listener: (_, state) {
              if (state.status.isSubmissionFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(S.of(context).error)));
              }

              if (state.status.isSubmissionSuccess) {
                final msg = point.isEmpty
                    ? state.deleteAtInput.value.isEmpty
                        ? S.of(context).pointPostedSuccessfully
                        : S.of(context).pointCreatedSuccessfully
                    : S.of(context).pointUpdatedSuccessfully;

                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(msg)));

                Navigator.of(context).pop();
              }
            },
            child: SafeArea(
              child: ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: _MediaInput(),
                  ),
                  const _TitleInput(),
                  const _PriceInput(),
                  const _DescriptionInput(),
                  const _TagsInput(),
                  const _AvailableInput(),
                  _SubmitButton(point: point),
                ],
              ),
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
      builder: (_, state) {
        return AppButton(
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(
              point.isEmpty ? S.of(context).postBtn : S.of(context).saveBtn),
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
    final tags = {
      Tag.vegan: S.of(context).vegan,
      Tag.vegetarian: S.of(context).vegetarian,
      Tag.glutenFree: S.of(context).glutenFree,
      Tag.kosher: S.of(context).kosher,
    };

    return Column(
      children: [
        ListTile(
          title: Text(S.of(context).tags),
          subtitle: BlocBuilder<PointFormCubit, PointFormState>(
            buildWhen: (previous, current) => previous != current,
            builder: (_, state) {
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var tag in tags.entries)
                      Padding(
                        key: Key(tag.value),
                        padding: const EdgeInsets.only(left: 2.0),
                        child: InputChip(
                          elevation: 1.0,
                          selectedColor: Colors.white,
                          backgroundColor: Colors.white,
                          label: Text(
                            tag.value,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onSelected: (selected) => context
                              .read<PointFormCubit>()
                              .toggleTag(tag.key.title),
                          selected:
                              state.tagsInput.value.contains(tag.key.title),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
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
        builder: (_, state) {
          return TextFormField(
            key: const Key('_PriceInput'),
            keyboardType: TextInputType.number,
            maxLines: null,
            maxLength: 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<PointFormCubit>().changePrice(value),
            decoration: InputDecoration(
              labelText: S.of(context).price,
              errorText:
                  state.priceInput.invalid ? S.of(context).invalid : null,
              suffix: const Text('₪'),
            ),
            textAlign: TextAlign.left,
            initialValue: state.priceInput.value.isEmpty
                ? null
                : humanz.money(state.priceInput.value, ''),
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
      builder: (_, state) {
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
              labelText: S.of(context).description,
              errorText:
                  state.descriptionInput.invalid ? S.of(context).invalid : null,
            ),
            initialValue: state.descriptionInput.value,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
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
        builder: (_, state) {
          return TextFormField(
            key: const Key('_TitleInput'),
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: 60,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<PointFormCubit>().changeTitle(value),
            decoration: InputDecoration(
              labelText: S.of(context).title,
              errorText:
                  state.titleInput.invalid ? S.of(context).invalid : null,
            ),
            initialValue: state.titleInput.value,
            onEditingComplete: () => FocusScope.of(context).nextFocus(),
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

class _AvailableInput extends StatelessWidget {
  const _AvailableInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PointFormCubit, PointFormState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return SwitchListTile(
          title: Text(state.isAvailable
              ? S.of(context).available
              : S.of(context).unavailable),
          subtitle: Text(S.of(context).availableHelperText),
          value: state.isAvailable,
          onChanged: (bool value) {
            if (!value || state.canPostPoint) {
              return context.read<PointFormCubit>().changeAvailable(value);
            }

            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                  SnackBar(content: Text(S.of(context).tooManyPointsError)));
          },
        );
      },
    );
  }
}
