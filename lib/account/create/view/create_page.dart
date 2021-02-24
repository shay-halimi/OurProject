import 'package:flutter/material.dart';

class CreatePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreatePage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('צור חשבון')),
      body: Container(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'תמונת פרופיל',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'שם תצוגה',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'אודות',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'צור חשבון',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
