import 'package:get_it/get_it.dart';

/// To get an API key, sign up here:
/// https://home.openweathermap.org/users/sign_up
///

final sl = GetIt.instance;

void setupInjection() {
  // Register the API key
  sl.registerSingleton<String>('c8c70dc3c906d40947ccc93b0c4d5b97',
      instanceName: 'api_key');
}
