package com.pantoo.presensi

import android.content.Context
import com.baseflow.geolocator.GeolocatorPlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.PluginRegistry

/** UI uses the location plugin; Geolocator is only used by the background isolate.
 * Its automatic service binding must not add a service-start deadline while the
 * first debug UI is being JIT-compiled. Background engines keep normal registration.
 */
class UiFlutterEngine(context: Context, waitForRestorationData: Boolean) :
    FlutterEngine(context, null, false, waitForRestorationData) {
    private var uiRegistry: PluginRegistry? = null

    override fun getPlugins(): PluginRegistry {
        val registry = super.getPlugins()
        return uiRegistry ?: object : PluginRegistry by registry {
            override fun add(plugin: FlutterPlugin) {
                if (plugin !is GeolocatorPlugin) registry.add(plugin)
            }

            override fun add(plugins: Set<FlutterPlugin>) {
                plugins.forEach { add(it) }
            }
        }.also { uiRegistry = it }
    }
}
