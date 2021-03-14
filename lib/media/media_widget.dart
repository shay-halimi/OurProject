import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({
    Key key,
    @required this.media,
  }) : super(key: key);

  final String media;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.9,
      child: Image.network(
        media,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }
}
