import 'dart:developer';

import 'package:doplsnew/helpers/routes.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
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
      log('OnUriLink Error: $err');
    });
  }

  static uniHandler(Uri? uri) async {
    if (uri == null || uri.queryParameters.isEmpty) return;

    Map<String, String> param = uri.queryParameters;
    String receivedCode = param['routes'] ?? '';

    if (receivedCode.isNotEmpty) {
      _code = receivedCode;

      // Cek apakah user sudah login
      bool isLoggedIn = await checkLoginStatus();

      if (!isLoggedIn) {
        // Jika belum login, arahkan ke halaman login dan simpan rute tujuan
        if (ContextUtility.context != null) {
          ContextUtility.navigator?.pushReplacementNamed(
            '/login',
            arguments: {
              'redirectRoute': receivedCode, // Simpan rute tujuan
            },
          );
        }
      } else {
        // Jika sudah login, arahkan langsung ke rute tujuan
        navigateToRoute(receivedCode);
      }
    }
  }

  static Future<bool> checkLoginStatus() async {
    // Cek apakah user sudah login dengan mengecek token di GetStorage
    final storage = GetStorage();
    final token =
        storage.read('userToken'); // Token yang disimpan setelah login
    return token != null &&
        token.isNotEmpty; // Jika token ada, dianggap sudah login
  }

  static void navigateToRoute(String code) {
    String route = AppRoutes.mapCodeToRoute(code);

    if (ContextUtility.context != null) {
      ContextUtility.navigator?.pushNamed(
        route,
        arguments: code,
      );
    }
  }
}
