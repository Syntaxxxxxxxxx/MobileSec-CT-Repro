package edu.mobilesec.ctrepro

data class CtEvent(
    val experimentId: String,
    val timestampMs: Long,
    val relativeMsFromLaunch: Long,
    val eventName: String,
    val eventCode: Int,
    val url: String,
    val browserPackage: String,
    val androidVersion: String,
    val browserVersion: String,
    val note: String
) {
    fun toCsvRow(): List<String> = listOf(
        experimentId,
        timestampMs.toString(),
        relativeMsFromLaunch.toString(),
        eventName,
        eventCode.toString(),
        url,
        browserPackage,
        androidVersion,
        browserVersion,
        note
    )
}
