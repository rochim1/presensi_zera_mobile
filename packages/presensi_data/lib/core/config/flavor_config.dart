import 'package:firebase_core/firebase_core.dart';
import 'package:presensi_data/presensi_data.dart';

class FlavorConfig {
  final Env? env;
  final String? name;
  final EnvValues? values;

  static FlavorConfig? _instance;

  String? _appId;
  String? _token;
  String? _baseApi;

  String? get token => _token;
  String? get appId => _appId;
  String? get baseApi => _baseApi;

  set appId(String? value) => _appId = value;
  set token(String? value) => _token = value;
  set baseApi(String? value) => _baseApi = value;

  void Function()? onUnauthorized;
  void Function(String message)? onConnectionError;

  factory FlavorConfig.init({required Env? env, required EnvValues? values}) {
    _instance ??= FlavorConfig._internal(
      env: env,
      name: env.toString().split(".")[env.toString().split(".").length - 1],
      values: values,
    );
    return _instance!;
  }

  FlavorConfig._internal({this.env, this.name, this.values});

  static FlavorConfig get instance => _instance!;

  static bool isProduction() => _instance!.env == Env.PRODUCTION;
  static bool isDevelopment() => _instance!.env == Env.DEVELOPMENT;
  static bool isStaging() => _instance!.env == Env.STAGING;
}

class EnvValues {
  final String? baseApi;
  final String? appId;
  final String? appName;
  final Duration? delay;
  final bool? debug;
  final bool? printResponse;
  final String? apiVersion;
  final FirebaseOptions options;

  EnvValues({
    this.appId,
    required this.baseApi,
    required this.options,
    required this.appName,
    required this.delay,
    required this.debug,
    required this.printResponse,
    required this.apiVersion,
  });
}
