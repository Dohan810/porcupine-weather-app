import 'package:flutter/material.dart';
import 'package:open_weather_example_flutter/src/features/weather/presentation/weather_page.dart';

class NoResultsPage extends StatelessWidget {
  const NoResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlurWrapper(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/gifs/sunIsWarm.gif',
              width: 180,
              height: 180,
            ),
            const SizedBox(height: 20),
            Text(
              'No clouds found',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
