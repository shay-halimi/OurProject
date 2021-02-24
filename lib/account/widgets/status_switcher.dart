import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/account/account.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toggle_switch/toggle_switch.dart';

class StatusSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountBloc, AccountState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          if (state.status == AccountStateStatus.loaded) {
            return Column(
              children: [
                ToggleSwitch(
                  initialLabelIndex: state.account.status.index,
                  labels: AccountStatus.values
                      .map((e) =>
                          e == AccountStatus.values[1] ? "זמין" : "לא זמין")
                      .toList(),
                  onToggle: (index) {
                    context
                        .read<AccountBloc>()
                        .setStatus(AccountStatus.values[index]);
                  },
                ),
                if (state.account.status == AccountStatus.available)
                  Text(
                      "אתה זמין, מספר הטלפון שלך מוצג ללקוחות והם יכולים להתקשר")
                else
                  Text("אתה לא זמין, לקוחות יכולים לשלוח הזמנות"),
              ],
            );
          }

          return CircularProgressIndicator();
        });
  }
}
