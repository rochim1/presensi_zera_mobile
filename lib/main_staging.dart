import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presensi_data/presensi_data.dart';
import 'app.dart';
import 'bootstrap.dart';

Future<void> main() async {
  // Load Env with flavor name
  await dotenv.load(fileName: ".env.staging");

  bootstrap(
    flavor: FlavorConfig.init(
      env: Env.STAGING,
      values: EnvValues(
        appName: 'Pantoo HR [STG]',
        apiVersion: '1.0.0',
        baseApi: dotenv.env['BASE_API'],
        debug: true,
        delay: const Duration(hours: 2),
        printResponse: true,
        options: FirebaseOptions(
          apiKey: dotenv.env['API_KEY']!,
          appId: dotenv.env['APP_ID']!,
          messagingSenderId: dotenv.env['MESSAGING_SENDER_ID']!,
          projectId: dotenv.env['PROJECT_ID']!,
          storageBucket: dotenv.env['STORAGE_BUCKET']!,
        ),
      ),
    ),
    () => const App(),
  );
}
