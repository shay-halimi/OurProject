import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({
    Key key,
    this.url,
    this.image,
    this.aspectRatio = 16 / 9,
    this.maxHeight = double.infinity,
  })  : assert(url == null || image == null),
        super(key: key);

  final String url;
  final ImageProvider image;
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
              child: Image(
                image: image ?? CachedNetworkImageProvider(url),
                fit: BoxFit.cover,
                loadingBuilder: (_, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
