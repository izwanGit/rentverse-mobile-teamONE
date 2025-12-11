// Utility helpers for making backend URLs accessible from different devices
// (emulator, simulator, physical devices). This keeps URLs intact for
// publicly-hosted HTTPS resources while rewriting localhost addresses used
// during local development so Android emulators can reach them.

String? makeDeviceAccessibleUrl(String? url) {
  if (url == null || url.isEmpty) return null;

  // If the backend returned a localhost/127.0.0.1 URL (common in dev),
  // Android emulator must use 10.0.2.2 to access the host machine.
  // iOS simulator and physical devices usually can reach the host
  // using the machine IP or a tunneling URL — we don't rewrite for them.
  final lower = url.toLowerCase();
  if (lower.startsWith('http://127.0.0.1') ||
      lower.startsWith('http://localhost')) {
    return url.replaceFirst(
      RegExp(r'http://(127\.0\.0\.1|localhost)', caseSensitive: false),
      'http://10.0.2.2',
    );
  }

  // If the URL is a relative path (starts with '/'), return it as-is so
  // callers can decide whether to prefix a base URL. Otherwise return
  // the original URL (but ensure it's a valid encoded URI string).
  try {
    return Uri.parse(url).toString();
  } catch (_) {
    return Uri.encodeFull(url);
  }
}
