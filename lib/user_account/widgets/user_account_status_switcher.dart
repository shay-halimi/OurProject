import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/user_account/user_account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAccountStatusSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => context
                .read<UserAccountBloc>()
                .updateUserStatus(AccountStatus.closed),
            child: Text("סגור"),
          ),
        ),
        Expanded(
          child: TextButton(
            onPressed: () => context
                .read<UserAccountBloc>()
                .updateUserStatus(AccountStatus.open),
            child: Text("פתוח"),
          ),
        ),
      ],
    );
  }
}
