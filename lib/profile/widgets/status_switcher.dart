import 'package:cookpoint/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatusSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == ProfileStateStatus.loaded) {
            return Text(
              state.profile.available
                  ? 'אתה זמין, מספר הטלפון שלך מוצג ללקוחות והם יכולים להתקשר'
                  : 'אתה לא זמין, לקוחות יכולים לשלוח הזמנות',
            );
          }

          return const CircularProgressIndicator();
        });
  }
}
