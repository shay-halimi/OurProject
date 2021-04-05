import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({
    Key key,
    @required this.media,
    this.aspectRatio = 16 / 9,
    this.maxHeight = double.infinity,
  }) : super(key: key);

  final String media;
  final double aspectRatio;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Hero(
                tag: media,
                child: Image(
                  image: CachedNetworkImageProvider(media),
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
