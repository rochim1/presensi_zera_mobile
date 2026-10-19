package com.pantoo.presensi

import android.app.Application
import io.flutter.FlutterInjector

/** Begin asynchronous library/resource loading before Activity class loading.
 * The Activity still owns engine creation and plugin registration. No Dart,
 * account, storage or location work runs here.
 */
class DebugApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        FlutterInjector.instance().flutterLoader().startInitialization(this)
    }
}
