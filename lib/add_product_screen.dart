import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("add_product_screen"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: "search",
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                child: Text("PH"),
              ),
              accountName: Text("accountName"),
              accountEmail: Text("accountEmail"),
            ),
            ListTile(
              leading: Icon(Icons.local_offer),
              title: Text("local_offer"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("favorite"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.history),
              title: Text("history"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("settings"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.feedback),
              title: Text("feedback"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              leading: Icon(Icons.bug_report),
              title: Text("bug_report"),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: AddProductSample(),
      ),
    );
  }
}

class AddProductSample extends StatefulWidget {
  @override
  State<AddProductSample> createState() => AddProductSampleState();
}

class AddProductSampleState extends State<AddProductSample> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'location_picker',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'photo_picker',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'product_name_input',
                  ),
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'product_price_input',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Are you sure?"),
                            content: Text("all your changes.."),
                            actions: [
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("yes_close"),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("no_im_still_working_on_this"),
                              ),
                            ],
                          )).then(
                      (value) => value ? Navigator.of(context).pop() : null),
                  child: Text("add_product_cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text("add_product_ok"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
