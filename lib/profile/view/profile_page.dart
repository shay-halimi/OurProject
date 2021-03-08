import 'package:cookpoint/authentication/authentication.dart';
import 'package:cookpoint/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => ProfilePage());
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthenticationBloc bloc) => bloc.state.user);

    if (user.isEmpty) {
      return AuthenticationPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('החשבון שלי'),
        actions: [
          const ChangePhotoURLWidget(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              user.photoURL ??
                  'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Gal_Gadot_2018_cropped_retouched.jpg/250px-Gal_Gadot_2018_cropped_retouched.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Text(user.displayName ?? 'גל גדות'),
          ElevatedButton(
            child: const Text('שמור שינויים'),
            onPressed: () => Navigator.of(context).push<void>(
              PhoneNumberPage.route(),
            ),
          ),
        ],
      ),
    );
  }
}
