import 'dart:async';
import 'dart:io';

Future<bool> checkInternet() async {
  try {
      var result = await InternetAddress.lookup("google.com");
      bool isTrue = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      return isTrue;
    } on SocketException catch (_) {
      return false;
    }
}
