import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/user_account/user_account.dart';
import 'package:cookpoint/user_account/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserAccountPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => UserAccountPage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (_) {
          return UserAccountBloc(
            accountsRepository: context.read<AccountsRepository>(),
            user: user,
          )..add(FetchUserAccountEvent());
        },
        child: Column(
          children: [
            UserAccountStatusSwitcher(),
            UserAccountForm(),
          ],
        ),
      ),
    );
  }
}
