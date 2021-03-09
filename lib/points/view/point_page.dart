import 'package:cookpoint/media/media_widget.dart';
import 'package:cookpoint/points/points.dart';
import 'package:cookpoint/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:points_repository/points_repository.dart';

class PointPage extends StatelessWidget {
  const PointPage({
    Key key,
    @required this.point,
  }) : super(key: key);

  final Point point;

  static Route route({
    @required Point point,
  }) {
    return MaterialPageRoute<void>(
      builder: (_) => PointPage(point: point),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _photos(context),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        point.title,
                        style: theme.textTheme.headline5,
                      ),
                      Text(
                        '${point.price.amount.toStringAsFixed(2)} ₪',
                        style: theme.textTheme.headline5
                            .copyWith(fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                  TagsWidget(tags: point.tags),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          point.description,
                          style: theme.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ListTile(
        dense: true,
        leading: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/6/6a/Gal_Gadot_2018_cropped_retouched.jpg/250px-Gal_Gadot_2018_cropped_retouched.jpg',
          ),
        ),
        title: const Text('גל גדות'),
        subtitle: const Text('פתח תקווה'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(FontAwesomeIcons.whatsapp),
              onPressed: () => null,
            ),
            IconButton(
              icon: const Icon(Icons.call),
              onPressed: () => null,
            ),
            IconButton(
              icon: const Icon(Icons.directions),
              onPressed: () => null,
            ),
          ],
        ),
        onTap: () => null,
      ),
    );
  }

  Widget _photos(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Hero(
        tag: point.media.first,
        child: MediaWidget(media: point.media.first),
      ),
    );
  }
}
