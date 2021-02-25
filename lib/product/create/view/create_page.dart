import 'package:flutter/material.dart';

class AddProductPage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => AddProductPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('פרסם CookPoint')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text("TODO"),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'שם המאכל',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'מחיר',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              TextField(
                maxLines: null,
                decoration: InputDecoration(
                  labelText: 'תיאור המוצר',
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 5.0),
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'תגיות',
                  hintText: 'טבעוני, צמחוני וכו',
                  helperText: 'מופרדות בפסיק',
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "FloatingActionButtonCookPoint",
        tooltip: 'פרסם CookPoint',
        child: Icon(Icons.save),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
