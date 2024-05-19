import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextButton extends StatelessWidget {
  final String text;
  final String townName;
  final Color textColor;

  const LinkTextButton({
    super.key,
    required this.text,
    required this.townName,
    this.textColor = Colors.white, // Default color is white
  });

  void _launchURL(String townName) async {
    final Uri url = Uri(
      scheme: 'https',
      host: 'openweathermap.org',
      path: 'find',
      queryParameters: {'q': townName},
    );

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: const Key("UrlLauncher"),
      onTap: () => _launchURL(townName),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: textColor,
                  decoration: TextDecoration.underline,
                  decorationColor: textColor),
            ),
          ),
          const SizedBox(width: 2), // Replacing addSpace function with SizedBox
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: textColor,
            size: 12,
          ),
        ],
      ),
    );
  }
}
