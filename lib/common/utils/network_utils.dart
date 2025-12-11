/// Keep backend URLs as-is but map `0.0.0.0` / `localhost` to your laptop IP
/// so images remain reachable on a physical Android device while still
/// allowing usage of the original endpoint strings in development.
String? makeDeviceAccessibleUrl(String? url) {
  if (url == null) return null;
  // Your laptop IP (use your machine's interface IP so a physical Android
  // device can reach services hosted on your laptop).
  const String laptopIp = '10.110.155.17';

  // Replace common host placeholders with the laptop IP so the device can
  // reach the backend. Handles both `0.0.0.0` and `localhost`.
  if (url.contains('0.0.0.0') || url.contains('localhost')) {
    try {
      return url.replaceAll(RegExp(r'0\.0\.0\.0|localhost'), laptopIp);
    } catch (_) {
      // If replacement fails for any reason, fall through and return original URL.
    }
  }

  // Fallback: if nothing matched or replacement failed, return original URL.
  return url;
}
