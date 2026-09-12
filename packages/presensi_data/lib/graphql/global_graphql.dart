mixin GlobalGraphQl {
  /// query for get versioning BE
  String get checkVersion => r'''query CheckVersion {
  CheckVersion {
    version
  }
}''';

  /// muatation for save device id from token firebase
  String get saveDeviceAppsId =>
      r'''mutation SaveDeviceAppsID($input: messagingInput) {
  saveDeviceAppsID(input: $input) {
    apps_id
    device
    model_device
  }
}''';
}
