import 'package:cookpoint/account/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShowPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ShowPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("הפרופיל שלי"),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == AccountStateStatus.loaded) {
            return Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          child: Image.network(state.account.photoUrl),
                        ),
                        Text(state.account.displayName),
                        Text(state.account.about),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return CircularProgressIndicator();
        },
      ),
    );
  }
}
