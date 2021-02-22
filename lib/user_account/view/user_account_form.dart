import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/user_account/user_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAccountForm extends StatelessWidget {
  const UserAccountForm({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<UserAccountBloc, UserAccountState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == AccountStateStatus.loaded) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(
                  children: [
                    Text("שם לתצוגה: "),
                    Text(state.account.displayName),
                  ],
                ),
                Row(
                  children: [
                    Text("תמונת פרופיל: "),
                    Text(state.account.profilePhoto),
                  ],
                ),
                Row(
                  children: [
                    Text("אודות: "),
                    Text(state.account.about),
                  ],
                ),
                Row(
                  children: [
                    Text("מצב: "),
                    Text(state.account.status == AccountStatus.closed
                        ? " ישן "
                        : " על המפה "),
                  ],
                ),
              ],
            );
          }

          return Column(
            children: [
              CircularProgressIndicator(),
            ],
          );
        },
      ),
    );
  }
}
