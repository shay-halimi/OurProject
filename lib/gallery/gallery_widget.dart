import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class GalleryWidget extends StatefulWidget {
  final Icon icon;
  final ValueChanged<String> onDownloadUrl;

  const GalleryWidget({
    Key key,
    @required this.icon,
    @required this.onDownloadUrl,
  }) : super(key: key);

  @override
  _GalleryWidgetState createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  Icon _iconState;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: _iconState ?? widget.icon,
      onPressed: () => showDialog<ImageSource>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => true,
            child: AlertDialog(
              title: Text("בחר מקור תמונה"),
              actions: <Widget>[
                TextButton(
                  child: Text("סגור"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("מחק"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("גלריה"),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
                TextButton(
                  child: Text("גלריה"),
                  onPressed: () {
                    Navigator.of(context).pop(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
      ).then((value) => _getImage(value)),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: source);

    final file = File(pickedFile.path);

    Reference reference =
        FirebaseStorage.instance.ref().child('gallery/').child(Uuid().v1());

    UploadTask task;

    if (kIsWeb) {
      task = reference.putData(await file.readAsBytes());
    } else {
      task = reference.putFile(file);
    }

    task.snapshotEvents.listen((TaskSnapshot snapshot) {
      switch (snapshot?.state) {
        case TaskState.success:
          snapshot.ref
              .getDownloadURL()
              .then((value) => this.widget.onDownloadUrl(value));
          setState(() {
            _iconState = widget.icon;
          });

          break;

        case TaskState.running:
          setState(() {
            _iconState = Icon(Icons.sync);
          });
          break;
        case TaskState.paused:
        case TaskState.canceled:
        case TaskState.error:
          setState(() {
            _iconState = Icon(Icons.sync_problem);
          });
          break;
      }
    });
  }
}
