package com.suvam.vitalflow

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine  // Add this import
import io.flutter.plugin.common.EventChannel
import android.hardware.Sensor
import android.hardware.SensorEvent
import android.hardware.SensorEventListener
import android.hardware.SensorManager
import android.content.Context

class MainActivity : FlutterActivity() {
    private val CHANNEL = "light_sensor"
    private lateinit var sensorManager: SensorManager
    private var lightSensor: Sensor? = null
    private var lightListener: SensorEventListener? = null
    private var eventSink: EventChannel.EventSink? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    startLightSensor()
                }

                override fun onCancel(arguments: Any?) {
                    stopLightSensor()
                    eventSink = null
                }
            }
        )
    }

    private fun startLightSensor() {
        sensorManager = getSystemService(Context.SENSOR_SERVICE) as SensorManager
        lightSensor = sensorManager.getDefaultSensor(Sensor.TYPE_LIGHT)
        if (lightSensor == null) {
            eventSink?.error("SENSOR_NOT_FOUND", "Light sensor not available", null)
            return
        }
        lightListener = object : SensorEventListener {
            override fun onSensorChanged(event: SensorEvent?) {
                val lux = event?.values?.get(0) ?: return
                eventSink?.success(lux)
            }
            override fun onAccuracyChanged(sensor: Sensor?, accuracy: Int) {}
        }
        sensorManager.registerListener(lightListener, lightSensor, SensorManager.SENSOR_DELAY_NORMAL)
    }

    private fun stopLightSensor() {
        lightListener?.let {
            sensorManager.unregisterListener(it)
        }
    }
}