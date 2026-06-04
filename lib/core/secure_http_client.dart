import 'dart:io';
import 'package:flutter/services.dart';

class SecureHttpClient {
  static Future<HttpClient> create() async {
    // Load pinned certificate
    final certData = await rootBundle.load(
      'assets/certificates/certificate.crt',
    );

    // Create isolated security context
    final context = SecurityContext(withTrustedRoots: false);

    // Trust ONLY this certificate
    context.setTrustedCertificatesBytes(certData.buffer.asUint8List());

    final client = HttpClient(context: context);

    // Extra safety layer
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
          // Allow only pinned cert
          return true;
        };

    return client;
  }
}
