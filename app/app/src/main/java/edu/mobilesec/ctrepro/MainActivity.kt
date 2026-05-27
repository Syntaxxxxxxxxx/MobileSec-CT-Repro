package edu.mobilesec.ctrepro

import android.app.Activity
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import android.view.Gravity
import android.view.View
import android.view.inputmethod.EditorInfo
import android.webkit.URLUtil
import android.widget.Button
import android.widget.EditText
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
import androidx.browser.customtabs.CustomTabsCallback
import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsIntent
import androidx.browser.customtabs.CustomTabsService
import androidx.browser.customtabs.CustomTabsServiceConnection
import androidx.browser.customtabs.CustomTabsSession
import java.io.File
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class MainActivity : Activity() {

    private lateinit var experimentInput: EditText
    private lateinit var urlInput: EditText
    private lateinit var browserInfoView: TextView
    private lateinit var eventLogView: TextView

    private val events = mutableListOf<CtEvent>()
    private var selectedBrowserPackage: String = ""
    private var selectedBrowserVersion: String = ""
    private var customTabsSession: CustomTabsSession? = null
    private var serviceConnection: CustomTabsServiceConnection? = null
    private var currentUrl: String = DEFAULT_URL
    private var launchStartedElapsedMs: Long = 0L
    private val mainHandler = Handler(Looper.getMainLooper())

    private val callback = object : CustomTabsCallback() {
        override fun onNavigationEvent(navigationEvent: Int, extras: Bundle?) {
            recordEvent(
                eventName = navigationEventName(navigationEvent),
                eventCode = navigationEvent,
                url = currentUrl,
                note = "extras=${summarizeBundle(extras)}"
            )
        }

        override fun extraCallback(callbackName: String, args: Bundle?) {
            recordEvent(
                eventName = "extraCallback:$callbackName",
                eventCode = EXTRA_CALLBACK_CODE,
                url = currentUrl,
                note = "bundle=${summarizeBundle(args)}"
            )
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        selectedBrowserPackage = chooseCustomTabsPackage()
        selectedBrowserVersion = getPackageVersion(selectedBrowserPackage)
        setContentView(buildUi())
        applyIntentConfiguration(intent)
        updateBrowserInfo()
        bindCustomTabsService()
        if (intent.getBooleanExtra(EXTRA_AUTO_LAUNCH, false)) {
            mainHandler.postDelayed({ launchCustomTab() }, AUTO_LAUNCH_DELAY_MS)
        }
    }

    override fun onDestroy() {
        serviceConnection?.let {
            runCatching { unbindService(it) }
        }
        super.onDestroy()
    }

    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        setIntent(intent)
        applyIntentConfiguration(intent)
        if (intent?.getBooleanExtra(EXTRA_AUTO_LAUNCH, false) == true) {
            mainHandler.postDelayed({ launchCustomTab() }, AUTO_LAUNCH_DELAY_MS)
        }
    }

    private fun buildUi(): View {
        val root = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            setPadding(dp(16), dp(14), dp(16), dp(14))
        }

        root.addView(TextView(this).apply {
            text = "Custom Tabs Callback Recorder"
            textSize = 22f
            setTextColor(0xff111111.toInt())
        })

        root.addView(TextView(this).apply {
            text = "仅用于本地 mock server 实验。默认 URL 指向 Android 模拟器可访问的 10.0.2.2。"
            textSize = 13f
            setPadding(0, dp(4), 0, dp(10))
        })

        experimentInput = EditText(this).apply {
            hint = "experiment_id"
            setSingleLine(true)
            setText("E01_callback_baseline")
            imeOptions = EditorInfo.IME_ACTION_NEXT
        }
        root.addView(experimentInput, matchWrap())

        urlInput = EditText(this).apply {
            hint = "URL"
            setSingleLine(true)
            setText(DEFAULT_URL)
            inputType = android.text.InputType.TYPE_TEXT_VARIATION_URI
            imeOptions = EditorInfo.IME_ACTION_GO
            setOnEditorActionListener { _, actionId, _ ->
                if (actionId == EditorInfo.IME_ACTION_GO) {
                    launchCustomTab()
                    true
                } else {
                    false
                }
            }
        }
        root.addView(urlInput, matchWrap())

        browserInfoView = TextView(this).apply {
            textSize = 13f
            setPadding(0, dp(8), 0, dp(8))
        }
        root.addView(browserInfoView, matchWrap())

        val buttons = LinearLayout(this).apply {
            orientation = LinearLayout.HORIZONTAL
            gravity = Gravity.CENTER_VERTICAL
        }
        buttons.addView(Button(this).apply {
            text = "打开 Custom Tab"
            setOnClickListener { launchCustomTab() }
        }, weightWrap())
        buttons.addView(Button(this).apply {
            text = "清空"
            setOnClickListener { clearEvents() }
        }, weightWrap())
        buttons.addView(Button(this).apply {
            text = "导出 CSV"
            setOnClickListener { exportCsv() }
        }, weightWrap())
        root.addView(buttons, matchWrap())

        eventLogView = TextView(this).apply {
            textSize = 12f
            typeface = android.graphics.Typeface.MONOSPACE
            setTextIsSelectable(true)
            text = "暂无事件。"
        }
        val scrollView = ScrollView(this).apply {
            addView(eventLogView)
            setPadding(0, dp(10), 0, 0)
        }
        root.addView(scrollView, LinearLayout.LayoutParams(
            LinearLayout.LayoutParams.MATCH_PARENT,
            0,
            1f
        ))

        return root
    }

    private fun applyIntentConfiguration(intent: Intent?) {
        val experimentId = intent?.getStringExtra(EXTRA_EXPERIMENT_ID).orEmpty()
        if (experimentId.isNotBlank()) {
            experimentInput.setText(experimentId)
        }

        val targetUrl = intent?.getStringExtra(EXTRA_URL) ?: intent?.dataString ?: DEFAULT_URL
        if (targetUrl.isNotBlank()) {
            urlInput.setText(targetUrl)
            currentUrl = targetUrl
        }
    }

    private fun bindCustomTabsService() {
        if (selectedBrowserPackage.isBlank()) {
            recordEvent("BROWSER_NOT_FOUND", -1, currentUrl, "未找到支持 Custom Tabs 的浏览器")
            return
        }

        serviceConnection = object : CustomTabsServiceConnection() {
            override fun onCustomTabsServiceConnected(name: ComponentName, client: CustomTabsClient) {
                client.warmup(0L)
                customTabsSession = client.newSession(callback)
                selectedBrowserPackage = name.packageName
                selectedBrowserVersion = getPackageVersion(selectedBrowserPackage)
                updateBrowserInfo()
                recordEvent("SERVICE_CONNECTED", 0, currentUrl, "component=${name.flattenToShortString()}")
            }

            override fun onServiceDisconnected(name: ComponentName?) {
                customTabsSession = null
                recordEvent("SERVICE_DISCONNECTED", 0, currentUrl, "component=${name?.flattenToShortString().orEmpty()}")
            }
        }

        val bound = CustomTabsClient.bindCustomTabsService(
            this,
            selectedBrowserPackage,
            serviceConnection as CustomTabsServiceConnection
        )
        if (!bound) {
            recordEvent("SERVICE_BIND_FAILED", -1, currentUrl, "browser_package=$selectedBrowserPackage")
        }
    }

    private fun launchCustomTab() {
        val inputUrl = urlInput.text.toString().trim()
        if (!URLUtil.isHttpUrl(inputUrl) && !URLUtil.isHttpsUrl(inputUrl)) {
            Toast.makeText(this, "请输入 http 或 https URL", Toast.LENGTH_SHORT).show()
            return
        }
        currentUrl = inputUrl
        launchStartedElapsedMs = SystemClock.elapsedRealtime()

        if (selectedBrowserPackage.isBlank()) {
            recordEvent("LAUNCH_SKIPPED", -1, currentUrl, "未找到支持 Custom Tabs 的浏览器，跳过 ACTION_VIEW fallback")
            return
        }

        val customTabsIntent = CustomTabsIntent.Builder(customTabsSession)
            .setShowTitle(true)
            .build()
        customTabsIntent.intent.setPackage(selectedBrowserPackage)

        recordEvent("LAUNCH_REQUESTED", 0, currentUrl, "准备打开 Custom Tab")
        runCatching {
            customTabsIntent.launchUrl(this, Uri.parse(currentUrl))
        }.onFailure { throwable ->
            recordEvent("LAUNCH_FAILED", -1, currentUrl, throwable.message.orEmpty())
            Toast.makeText(this, "打开 Custom Tab 失败：${throwable.message}", Toast.LENGTH_LONG).show()
        }
    }

    private fun recordEvent(eventName: String, eventCode: Int, url: String, note: String) {
        if (Looper.myLooper() != Looper.getMainLooper()) {
            mainHandler.post { recordEvent(eventName, eventCode, url, note) }
            return
        }

        val now = System.currentTimeMillis()
        val relative = if (launchStartedElapsedMs == 0L) 0L else {
            SystemClock.elapsedRealtime() - launchStartedElapsedMs
        }
        val event = CtEvent(
            experimentId = experimentInput.text.toString().ifBlank { "E01_callback_baseline" },
            timestampMs = now,
            relativeMsFromLaunch = relative,
            eventName = eventName,
            eventCode = eventCode,
            url = url,
            browserPackage = selectedBrowserPackage,
            androidVersion = "Android ${Build.VERSION.RELEASE} API ${Build.VERSION.SDK_INT}",
            browserVersion = selectedBrowserVersion,
            note = note
        )
        events.add(event)
        Log.i(LOG_TAG, formatLogLine(event))
        renderEvents()
        runCatching { writeCsv("events_latest.csv") }
    }

    private fun renderEvents() {
        if (events.isEmpty()) {
            eventLogView.text = "暂无事件。"
            return
        }
        eventLogView.text = events.joinToString(separator = "\n\n") { event ->
            buildString {
                append(event.eventName)
                append(" code=")
                append(event.eventCode)
                append(" t+=")
                append(event.relativeMsFromLaunch)
                append("ms\n")
                append("url=")
                append(event.url)
                append("\n")
                append("browser=")
                append(event.browserPackage)
                append(" ")
                append(event.browserVersion)
                append("\n")
                append(event.note)
            }
        }
    }

    private fun clearEvents() {
        events.clear()
        launchStartedElapsedMs = 0L
        renderEvents()
        Toast.makeText(this, "事件已清空", Toast.LENGTH_SHORT).show()
    }

    private fun exportCsv() {
        if (events.isEmpty()) {
            Toast.makeText(this, "没有可导出的事件", Toast.LENGTH_SHORT).show()
            return
        }
        val stamp = SimpleDateFormat("yyyyMMdd_HHmmss", Locale.US).format(Date())
        val file = writeCsv("events_$stamp.csv")
        recordEvent("CSV_EXPORTED", 0, currentUrl, "path=${file.absolutePath}")
        Toast.makeText(this, "CSV 已导出：${file.absolutePath}", Toast.LENGTH_LONG).show()
    }

    private fun writeCsv(fileName: String): File {
        val dir = File(getExternalFilesDir(Environment.DIRECTORY_DOCUMENTS), "ct_repro")
        dir.mkdirs()
        val file = File(dir, fileName)
        file.writeText(buildCsv(), Charsets.UTF_8)
        return file
    }

    private fun buildCsv(): String {
        val header = listOf(
            "experiment_id",
            "timestamp_ms",
            "relative_ms_from_launch",
            "event_name",
            "event_code",
            "url",
            "browser_package",
            "android_version",
            "browser_version",
            "note"
        )
        return buildString {
            append(header.joinToString(",") { csvEscape(it) })
            append("\n")
            events.forEach { event ->
                append(event.toCsvRow().joinToString(",") { csvEscape(it) })
                append("\n")
            }
        }
    }

    private fun chooseCustomTabsPackage(): String {
        val preferred = listOf(
            "com.android.chrome",
            "com.chrome.beta",
            "com.microsoft.emmx",
            "com.brave.browser",
            "org.mozilla.firefox"
        )
        val available = queryCustomTabsPackages()
        return preferred.firstOrNull { it in available } ?: available.firstOrNull().orEmpty()
    }

    private fun queryCustomTabsPackages(): Set<String> {
        val serviceIntent = Intent(CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION)
        val services = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            packageManager.queryIntentServices(
                serviceIntent,
                PackageManager.ResolveInfoFlags.of(0)
            )
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentServices(serviceIntent, 0)
        }
        return services.mapNotNull { it.serviceInfo?.packageName }.toSet()
    }

    private fun getPackageVersion(packageName: String): String {
        if (packageName.isBlank()) return ""
        return runCatching {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                packageManager.getPackageInfo(packageName, PackageManager.PackageInfoFlags.of(0)).versionName
            } else {
                @Suppress("DEPRECATION")
                packageManager.getPackageInfo(packageName, 0).versionName
            }
        }.getOrNull().orEmpty()
    }

    private fun updateBrowserInfo() {
        browserInfoView.text = if (selectedBrowserPackage.isBlank()) {
            "浏览器：未找到支持 Custom Tabs 的浏览器"
        } else {
            "浏览器：$selectedBrowserPackage $selectedBrowserVersion"
        }
    }

    private fun navigationEventName(code: Int): String = when (code) {
        CustomTabsCallback.NAVIGATION_STARTED -> "NAVIGATION_STARTED"
        CustomTabsCallback.NAVIGATION_FINISHED -> "NAVIGATION_FINISHED"
        CustomTabsCallback.NAVIGATION_FAILED -> "NAVIGATION_FAILED"
        CustomTabsCallback.NAVIGATION_ABORTED -> "NAVIGATION_ABORTED"
        CustomTabsCallback.TAB_SHOWN -> "TAB_SHOWN"
        CustomTabsCallback.TAB_HIDDEN -> "TAB_HIDDEN"
        else -> "NAVIGATION_EVENT_$code"
    }

    private fun summarizeBundle(bundle: Bundle?): String {
        if (bundle == null || bundle.isEmpty) return "{}"
        return bundle.keySet().joinToString(prefix = "{", postfix = "}") { key ->
            "$key=${bundle.get(key)}"
        }
    }

    private fun formatLogLine(event: CtEvent): String {
        return event.toCsvRow().joinToString(" | ")
    }

    private fun csvEscape(value: String): String {
        val escaped = value.replace("\"", "\"\"")
        return "\"$escaped\""
    }

    private fun dp(value: Int): Int = (value * resources.displayMetrics.density).toInt()

    private fun matchWrap(): LinearLayout.LayoutParams = LinearLayout.LayoutParams(
        LinearLayout.LayoutParams.MATCH_PARENT,
        LinearLayout.LayoutParams.WRAP_CONTENT
    )

    private fun weightWrap(): LinearLayout.LayoutParams = LinearLayout.LayoutParams(
        0,
        LinearLayout.LayoutParams.WRAP_CONTENT,
        1f
    )

    companion object {
        private const val DEFAULT_URL = "http://10.0.2.2:8000/basic"
        private const val LOG_TAG = "CT_REPRO"
        private const val EXTRA_CALLBACK_CODE = 10000
        private const val EXTRA_EXPERIMENT_ID = "experiment_id"
        private const val EXTRA_URL = "url"
        private const val EXTRA_AUTO_LAUNCH = "auto_launch"
        private const val AUTO_LAUNCH_DELAY_MS = 1500L
    }
}
