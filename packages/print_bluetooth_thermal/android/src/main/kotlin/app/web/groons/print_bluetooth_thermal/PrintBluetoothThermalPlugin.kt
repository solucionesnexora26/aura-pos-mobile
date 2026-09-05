package app.web.groons.print_bluetooth_thermal

import android.Manifest
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothSocket
import android.content.Context
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.core.content.ContextCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.Result
import java.io.OutputStream
import java.util.UUID
import java.util.concurrent.Executors

private const val TAG = "AuraPrintBluetooth"
private const val CHANNEL = "groons.web.app/print"
private val SPP_UUID: UUID = UUID.fromString("00001101-0000-1000-8000-00805F9B34FB")

/** Transparent Android transport for ESC/POS payloads. */
class PrintBluetoothThermalPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    private lateinit var context: Context
    private lateinit var channel: MethodChannel
    private val executor = Executors.newSingleThreadExecutor()
    private val mainHandler = Handler(Looper.getMainLooper())
    private val lock = Any()
    private var socket: BluetoothSocket? = null
    private var outputStream: OutputStream? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "ispermissionbluetoothgranted" -> result.success(hasConnectPermission())
            "bluetoothenabled" -> result.success(BluetoothAdapter.getDefaultAdapter()?.isEnabled == true)
            "pairedbluetooths" -> result.success(pairedDevices())
            "connectionstatus" -> result.success(isConnected())
            "connect" -> {
                val address = when (val arguments = call.arguments) {
                    is String -> arguments.trim()
                    is Map<*, *> -> arguments["mac"]?.toString()?.trim().orEmpty()
                    else -> ""
                }
                connect(address, result)
            }
            "writebytes" -> writeBytes(call.arguments, result)
            "disconnect" -> disconnect(result)
            else -> result.notImplemented()
        }
    }

    private fun hasConnectPermission(): Boolean {
        return Build.VERSION.SDK_INT < Build.VERSION_CODES.S ||
            ContextCompat.checkSelfPermission(
                context,
                Manifest.permission.BLUETOOTH_CONNECT,
            ) == PackageManager.PERMISSION_GRANTED
    }

    private fun pairedDevices(): List<String> {
        if (!hasConnectPermission()) return emptyList()
        val adapter = BluetoothAdapter.getDefaultAdapter() ?: return emptyList()
        return adapter.bondedDevices.map { "${it.name ?: "Bluetooth"}#${it.address}" }
    }

    private fun isConnected(): Boolean = synchronized(lock) {
        socket?.isConnected == true && outputStream != null
    }

    private fun connect(address: String, result: Result) {
        if (address.isBlank()) {
            result.error("INVALID_ADDRESS", "Bluetooth address is empty", null)
            return
        }
        executor.execute {
            var newSocket: BluetoothSocket? = null
            try {
                disconnectInternal()
                if (!hasConnectPermission()) {
                    postError(result, "BLUETOOTH_PERMISSION", "Bluetooth connect permission is not granted")
                    return@execute
                }
                val adapter = BluetoothAdapter.getDefaultAdapter()
                if (adapter == null || !adapter.isEnabled) {
                    postError(result, "BLUETOOTH_DISABLED", "Bluetooth adapter is disabled")
                    return@execute
                }
                if (!BluetoothAdapter.checkBluetoothAddress(address)) {
                    postError(result, "INVALID_ADDRESS", "Invalid Bluetooth address: $address")
                    return@execute
                }
                val device: BluetoothDevice = adapter.getRemoteDevice(address)
                adapter.cancelDiscovery()
                newSocket = device.createRfcommSocketToServiceRecord(SPP_UUID)
                newSocket.connect()
                synchronized(lock) {
                    socket = newSocket
                    outputStream = newSocket.outputStream
                }
                postResult(result, true)
            } catch (error: Exception) {
                try { newSocket?.close() } catch (_: Exception) {}
                Log.e(TAG, "connect failed", error)
                postError(
                    result,
                    "BLUETOOTH_CONNECT_FAILED",
                    "${error.javaClass.simpleName}: ${error.message ?: "no detail"}",
                )
            }
        }
    }

    private fun writeBytes(arguments: Any?, result: Result) {
        val values = arguments as? List<*> ?: run {
            result.success(false)
            return
        }
        val payload = try {
            ByteArray(values.size) { index ->
                val value = (values[index] as Number).toInt()
                require(value in 0..255) { "byte out of range at index $index: $value" }
                (value and 0xFF).toByte()
            }
        } catch (error: Exception) {
            Log.e(TAG, "invalid byte payload", error)
            result.success(false)
            return
        }

        executor.execute {
            try {
                val stream = synchronized(lock) { outputStream }
                if (stream == null) {
                    postResult(result, false)
                    return@execute
                }
                Log.d(TAG, "writebytes length=${payload.size} first=${hex(payload, 16)} last=${hexTail(payload, 16)}")
                // Deliberately no LF/CR/header. This is the exact Dart payload.
                stream.write(payload)
                stream.flush()
                postResult(result, true)
            } catch (error: Exception) {
                Log.e(TAG, "writebytes failed", error)
                disconnectInternal()
                postResult(result, false)
            }
        }
    }

    private fun disconnect(result: Result) {
        executor.execute {
            disconnectInternal()
            postResult(result, true)
        }
    }

    private fun disconnectInternal() {
        synchronized(lock) {
            try { outputStream?.flush() } catch (_: Exception) {}
            try { outputStream?.close() } catch (_: Exception) {}
            try { socket?.close() } catch (_: Exception) {}
            outputStream = null
            socket = null
        }
    }

    private fun postResult(result: Result, value: Boolean) {
        mainHandler.post { result.success(value) }
    }

    private fun postError(result: Result, code: String, message: String) {
        mainHandler.post { result.error(code, message, null) }
    }

    private fun hex(data: ByteArray, max: Int): String {
        return data.take(max).joinToString(" ") { "%02x".format(it.toInt() and 0xFF) }
    }

    private fun hexTail(data: ByteArray, max: Int): String {
        return data.takeLast(max).joinToString(" ") { "%02x".format(it.toInt() and 0xFF) }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        executor.execute { disconnectInternal() }
        executor.shutdown()
    }
}
