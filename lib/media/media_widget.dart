import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({
    Key key,
    @required this.media,
  }) : super(key: key);

  final String media;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: CachedNetworkImageProvider(media),
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
    );
  }
}
