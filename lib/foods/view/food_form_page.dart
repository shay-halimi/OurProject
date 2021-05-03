import 'package:cookpoint/foods/foods.dart';
import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/humanz.dart';
import 'package:cookpoint/legal/legal.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class FoodFormPage extends StatelessWidget {
  const FoodFormPage({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  static Route route({@required Food food}) {
    return MaterialPageRoute<void>(
      settings: RouteSettings(
        name: food.isEmpty ? '/foods/create' : '/foods/${food.id}/update',
      ),
      builder: (_) => RestaurantMiddleware(
        child: RestaurantTermsOfServiceMiddleware(
          child: FoodFormPage(food: food),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FoodFormCubit(
        food: food,
        foodsBloc: context.read<FoodsBloc>(),
      ),
      child: FoodForm(
        food: food,
      ),
    );
  }
}

class FoodForm extends StatelessWidget {
  const FoodForm({
    Key key,
    @required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    final status = context.select((FoodFormCubit cubit) => cubit.state.status);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          food.isEmpty
              ? S.of(context).createFoodPageTitle
              : S.of(context).updateFoodPageTitle,
        ),
        actions: [
          if (food.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: !status.isPure && status.isValidated
                  ? () => context.read<FoodFormCubit>().save()
                  : null,
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
                context.read<FoodFormCubit>().save();
                return true;
              }

              return discard;
            });
          },
          child: BlocListener<FoodFormCubit, FoodFormState>(
            listenWhen: (previous, current) => previous != current,
            listener: (_, state) {
              if (state.status.isSubmissionFailure) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(content: Text(S.of(context).error)));
              }

              if (state.status.isSubmissionSuccess) {
                final msg = food.isEmpty
                    ? state.deleteAtInput.value.isEmpty
                        ? S.of(context).foodPostedSuccessfully
                        : S.of(context).foodCreatedSuccessfully
                    : S.of(context).foodUpdatedSuccessfully;

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
                  _SubmitButton(food: food),
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
    @required this.food,
  }) : super(key: key);

  final Food food;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodFormCubit, FoodFormState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return AppButton(
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(
              food.isEmpty ? S.of(context).postBtn : S.of(context).saveBtn),
          onPressed: state.status.isValidated
              ? () => context.read<FoodFormCubit>().save()
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
          subtitle: BlocBuilder<FoodFormCubit, FoodFormState>(
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
                              .read<FoodFormCubit>()
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
      child: BlocBuilder<FoodFormCubit, FoodFormState>(
        buildWhen: (previous, current) =>
            previous.priceInput != current.priceInput,
        builder: (_, state) {
          return TextFormField(
            key: const Key('_PriceInput'),
            keyboardType: TextInputType.number,
            maxLength: 6,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<FoodFormCubit>().changePrice(value),
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
    return BlocBuilder<FoodFormCubit, FoodFormState>(
      buildWhen: (previous, current) =>
          previous.descriptionInput != current.descriptionInput,
      builder: (_, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: TextFormField(
            key: const Key('_DescriptionInput'),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            maxLength: state.descriptionInput.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<FoodFormCubit>().changeDescription(value),
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
      child: BlocBuilder<FoodFormCubit, FoodFormState>(
        buildWhen: (previous, current) =>
            previous.titleInput != current.titleInput,
        builder: (_, state) {
          return TextFormField(
            key: const Key('_TitleInput'),
            keyboardType: TextInputType.text,
            maxLines: 1,
            maxLength: state.titleInput.maxLength,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) =>
                context.read<FoodFormCubit>().changeTitle(value),
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
    return BlocBuilder<FoodFormCubit, FoodFormState>(
      buildWhen: (previous, current) =>
          previous.mediaInput != current.mediaInput,
      builder: (_, state) {
        return MediaDialog(
          media: state.mediaInput.value,
          onMediaChanged: (value) =>
              context.read<FoodFormCubit>().changeMedia(value),
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
    return BlocBuilder<FoodFormCubit, FoodFormState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) {
        return SwitchListTile(
          title: Text(state.available
              ? S.of(context).available
              : S.of(context).unavailable),
          subtitle: Text(S.of(context).availableHelperText),
          value: state.available,
          onChanged: (bool value) {
            return context.read<FoodFormCubit>().changeAvailable(value);
          },
        );
      },
    );
  }
}
