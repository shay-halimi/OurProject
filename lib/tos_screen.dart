import 'dart:ui';

import 'package:collaborative_food/map_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TosScreen extends StatelessWidget {

  final VoidCallback callback;

  const TosScreen({
    Key key,
    @required this.callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("images/tos.jpg"),
          fit: BoxFit.cover,
        )),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        "welcome_to_the_app",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                        maxLines: 4,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("tos_screen"),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  onPressed: callback,
                                  child: Text("let_s_start"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        InkWell(
                          child: Text(
                            "by_clicking_let_s_start_you_accepting_our_terms_of_service",
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2
                                .copyWith(fontSize: 10),
                          ),
                          onTap: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Text("terms_of_service"),
                                    content: SingleChildScrollView(child: Text("terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_oterms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body f_service_body terms_of_service_body terms_of_service_body terms_of_service_body terms_of_service_body ")),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.of(context).pop(),
                                        child: Text("terms_of_service_ok"),
                                      ),
                                    ]);
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
