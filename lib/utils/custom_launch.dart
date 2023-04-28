import 'package:url_launcher/url_launcher.dart';

customLaunchUrl(String url) async {
  return await launchUrl(Uri.parse(url));
}
