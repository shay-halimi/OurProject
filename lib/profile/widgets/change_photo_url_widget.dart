import 'package:accounts_repository/accounts_repository.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ChangePhotoURLWidget extends StatefulWidget {
  const ChangePhotoURLWidget({
    Key key,
  }) : super(key: key);

  @override
  _ChangePhotoURLWidgetState createState() => _ChangePhotoURLWidgetState();
}

enum DialogResponse { cancel, remove, openCamera, openGallery }

class _ChangePhotoURLWidgetState extends State<ChangePhotoURLWidget> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FontAwesomeIcons.camera),
      onPressed: () => showDialog<DialogResponse>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
            onWillPop: () async => true,
            child: AlertDialog(
              title: const Text('החלפת תמונת פרופיל'),
              actions: <Widget>[
                TextButton(
                  child: const Text('מחק תמונה קיימת'),
                  onPressed: () {
                    Navigator.of(context).pop(DialogResponse.remove);
                  },
                ),
                TextButton(
                  child: const Text('בחירה מהגלריה'),
                  onPressed: () {
                    Navigator.of(context).pop(DialogResponse.openGallery);
                  },
                ),
                TextButton(
                  child: const Text('צלם תמונה חדשה'),
                  onPressed: () {
                    Navigator.of(context).pop(DialogResponse.openCamera);
                  },
                ),
                TextButton(
                  child: const Text('ביטול'),
                  onPressed: () {
                    Navigator.of(context).pop(DialogResponse.cancel);
                  },
                ),
              ],
            ),
          );
        },
      ).then((response) {
        switch (response) {
          case DialogResponse.cancel:
            break;
          case DialogResponse.remove:
            context.read<ProfileBloc>().updatePhotoURL(Account.empty.photoURL);
            break;
          case DialogResponse.openCamera:
            // _getImage(ImageSource.camera);
            break;
          case DialogResponse.openGallery:
            // _getImage(ImageSource.gallery);
            break;
        }
      }),
    );
  }

// Future<void> _getImage(ImageSource source) async {
//   final picker = ImagePicker();
//
//   final pickedFile = await picker.getImage(source: source);
//
//   final file = File(pickedFile.path);
//
//   var reference =
//       FirebaseStorage.instance.ref().child('gallery/').child(Uuid().v1());
//
//   UploadTask task;
//
//   if (kIsWeb) {
//     task = reference.putData(await file.readAsBytes());
//   } else {
//     task = reference.putFile(file);
//   }
//
//   task.snapshotEvents.listen((TaskSnapshot snapshot) {
//     switch (snapshot?.state) {
//       case TaskState.success:
//         snapshot.ref.getDownloadURL().then(
//             (value) => context.read<ProfileBloc>().updatePhotoURL(value));
//         break;
//
//       case TaskState.running:
//       case TaskState.paused:
//       case TaskState.canceled:
//       case TaskState.error:
//         break;
//     }
//   });
// }
}
