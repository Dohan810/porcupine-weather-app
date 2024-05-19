import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/utils/formatting_utils.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTextButton extends StatelessWidget {
  final String text;
  final String townName;

  const LinkTextButton({
    super.key,
    required this.text,
    required this.townName,
  });

  void _launchURL(String townName) async {
    final Uri url = Uri(
      scheme: 'https',
      host: 'openweathermap.org',
      path: 'find',
      queryParameters: {'q': townName},
    );

    await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _launchURL(townName),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                decoration: TextDecoration.underline,
                decorationColor: Colors.white),
          ),
          addSpace(2),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white,
            size: 12,
          )
        ],
      ),
    );
  }
}
