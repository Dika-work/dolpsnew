import 'dart:developer';

import 'package:doplsnew/helpers/routes.dart';
import 'package:flutter/services.dart';
import 'package:uni_links2/uni_links.dart';

import 'context_util.dart';

class UniServices {
  static String _code = '';
  static String get code => _code;
  static bool get hasCode => _code.isNotEmpty;

  static void reset() => _code = '';

  static init() async {
    try {
      final Uri? uri = await getInitialUri();
      uniHandler(uri);
    } on PlatformException catch (_) {
      log('Failed to receive the code');
    } on FormatException catch (_) {
      log('Wrong format code received');
    }

    uriLinkStream.listen((Uri? uri) async {
      uniHandler(uri);
    }, onError: (err) {
      log('OnUriLInk Error: $err');
    });
  }

  static uniHandler(Uri? uri) {
    if (uri == null || uri.queryParameters.isEmpty) return;

    Map<String, String> param = uri.queryParameters;
    String receivedCode = param['routes'] ?? '';

    if (receivedCode.isNotEmpty) {
      _code = receivedCode;

      // Misalnya, asumsikan Anda memiliki fungsi yang memetakan kode ke rute
      String route = AppRoutes.mapCodeToRoute(
          receivedCode); // Anda perlu mendefinisikan fungsi ini

      if (ContextUtility.context != null) {
        ContextUtility.navigator?.pushNamed(
          route,
          arguments: receivedCode,
        );
      }
    }
  }
}
