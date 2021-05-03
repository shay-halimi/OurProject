import 'package:cookpoint/generated/l10n.dart';
import 'package:cookpoint/location/location.dart';
import 'package:cookpoint/media/media.dart';
import 'package:cookpoint/restaurant/restaurant.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:provider/provider.dart';

class RestaurantFormPage extends StatelessWidget {
  const RestaurantFormPage({
    Key key,
  }) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(
      settings: const RouteSettings(name: '/restaurants/create'),
      builder: (_) => const RestaurantMiddleware(
        child: RestaurantFormPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RestaurantFormCubit(
        restaurantBloc: context.read<RestaurantBloc>(),
        locationServices: context.read<LocationServices>(),
      ),
      child: const RestaurantForm(),
    );
  }
}

class RestaurantForm extends StatelessWidget {
  const RestaurantForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final restaurant =
        context.select((RestaurantBloc bloc) => bloc.state.restaurant);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(restaurant.isEmpty
            ? S.of(context).createAccountPageTitle
            : S.of(context).updateAccountPageTitle),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocListener<RestaurantFormCubit, RestaurantFormState>(
          listenWhen: (previous, current) => previous != current,
          listener: (_, state) {
            if (state.status.isSubmissionFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text(S.of(context).error)));
            }

            if (state.status.isSubmissionSuccess) {
              if (restaurant.isNotEmpty) {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(SnackBar(
                      content: Text(S.of(context).accountUpdatedSuccessfully)));

                Navigator.of(context).pop();
              }
            }
          },
          child: ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: _PhotoURLInput(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _DisplayNameInput(),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _AddressInput(),
                    ),

                    /// todo about
                    Center(
                      child: _SubmitButton(
                        restaurant: restaurant,
                      ),
                    ),
                  ],
                ),
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
    return BlocBuilder<RestaurantFormCubit, RestaurantFormState>(
      buildWhen: (previous, current) =>
          previous.addressInput != current.addressInput,
      builder: (_, state) {
        return TextFormField(
          key: const Key('_AddressInput'),
          keyboardType: TextInputType.streetAddress,
          maxLines: 1,
          onChanged: (value) =>
              context.read<RestaurantFormCubit>().changeAddressName(value),
          decoration: InputDecoration(
            labelText: S.of(context).address,
            errorText:
                state.addressInput.invalid ? S.of(context).invalid : null,
            helperText: S.of(context).addressHelperText,
          ),
          initialValue: state.addressInput.value.name,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
        );
      },
    );
  }
}

class _DisplayNameInput extends StatelessWidget {
  const _DisplayNameInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantFormCubit, RestaurantFormState>(
      buildWhen: (previous, current) =>
          previous.displayNameInput != current.displayNameInput,
      builder: (_, state) {
        return TextFormField(
          key: const Key('_DisplayNameInput'),
          keyboardType: TextInputType.text,
          maxLines: 1,
          maxLength: state.displayNameInput.maxLength,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          onChanged: (value) =>
              context.read<RestaurantFormCubit>().changeDisplayName(value),
          decoration: InputDecoration(
            labelText: S.of(context).displayName,
            errorText:
                state.displayNameInput.invalid ? S.of(context).invalid : null,
          ),
          initialValue: state.displayNameInput.value,
          onEditingComplete: () => FocusScope.of(context).nextFocus(),
        );
      },
    );
  }
}

class _PhotoURLInput extends StatelessWidget {
  const _PhotoURLInput({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantFormCubit, RestaurantFormState>(
      buildWhen: (previous, current) =>
          previous.photoURLInput != current.photoURLInput,
      builder: (_, state) {
        return PhotoURLWidget(
          photoURL: state.photoURLInput.value,
          onPhotoURLChanged: (value) {
            context.read<RestaurantFormCubit>().changePhotoURL(value);
          },
        );
      },
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key key,
    @required this.restaurant,
  }) : super(key: key);

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantFormCubit, RestaurantFormState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (_, state) {
        return AppButton(
          key: ValueKey(state.status),
          isInProgress: state.status.isSubmissionInProgress,
          child: Text(restaurant.isEmpty
              ? S.of(context).continueBtn
              : S.of(context).saveBtn),
          onPressed: state.status.isValidated
              ? () => context.read<RestaurantFormCubit>().save()
              : null,
        );
      },
    );
  }
}
