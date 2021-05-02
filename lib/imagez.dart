import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';

final imagez = const _Imagez();

class _Imagez {
  const _Imagez();

  ImageProvider url(String url) {
    return CachedNetworkImageProvider(_prepareURL(url));
  }

  String _prepareURL(String url) {
    final uri = Uri.tryParse(url);

    if (uri == null || uri.host.isEmpty) return url;

    var prepareURL = '';

    if (uri.isScheme('https')) {
      prepareURL = 'ssl:';
    }

    if (uri.host.isNotEmpty) {
      prepareURL += uri.host;
    }

    if (uri.hasPort) {
      prepareURL += ':${uri.port}';
    }

    if (uri.path.isNotEmpty) {
      prepareURL += uri.path;
    }

    if (uri.hasQuery) {
      prepareURL += '?${uri.query}';
    }

    if (uri.hasFragment) {
      prepareURL += '#${uri.fragment}';
    }

    return Uri.https('images.weserv.nl', '/',
        <String, Object>{'url': prepareURL, 'w': '1024'}).toString();
  }
}
