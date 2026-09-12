import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:presensi_data/presensi_data.dart';

class NetworkService {
  NetworkService() {
    observeNetwork();
  }

  Future<void> observeNetwork() async {
    Connectivity().onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.none)) {
        Fluttertoast.showToast(
          msg: MESSAGE_UNCONNECTED,
          toastLength: Toast.LENGTH_SHORT,
        );
      } else {
        Fluttertoast.showToast(
          msg: MESSAGE_CONNECTED,
          toastLength: Toast.LENGTH_SHORT,
        );
      }
    });
  }
}
