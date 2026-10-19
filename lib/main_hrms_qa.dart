// Local QA entry point. Never use for a production release.
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:presensi_data/presensi_data.dart';
import 'app.dart';
import 'bootstrap.dart';

Future<void> main() async {
  // Load Env with flavor name
  await dotenv.load(fileName: ".env.development");

  bootstrap(
    flavor: FlavorConfig.init(
      env: Env.STAGING,
      values: EnvValues(
        appName: 'Zera HRMS QA',
        apiVersion: '1.0.0',
        baseApi: const String.fromEnvironment('HRMS_QA_API', defaultValue: 'http://10.0.2.2:8086/graphql'),
        debug: true,
        delay: const Duration(minutes: 5),
        printResponse: false,
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
