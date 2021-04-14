import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MediaWidget extends StatelessWidget {
  const MediaWidget({
    Key key,
    this.url,
    this.image,
    this.aspectRatio = defaultAspectRatio,
    this.maxWidth = double.infinity,
    this.maxHeight = double.infinity,
  })  : assert(url != null && image == null),
        assert(image != null && url == null),
        assert(aspectRatio != null && aspectRatio > 0.0),
        assert(maxWidth == null || maxWidth > 0.0),
        assert(maxHeight == null || maxHeight > 0.0),
        super(key: key);

  static const defaultAspectRatio = 1 / 1;

  final String url;

  final ImageProvider image;

  final double aspectRatio;

  final double maxWidth;

  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      ),
      child: Row(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Hero(
                tag: image ?? url,
                child: Image(
                  image: image ?? CachedNetworkImageProvider(url),
                  fit: BoxFit.cover,
                  loadingBuilder: (_, child, loadingProgress) {
                    return loadingProgress == null
                        ? child
                        : const Center(child: CircularProgressIndicator());
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
