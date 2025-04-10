package com.example.flutter_alarm

import io.flutter.embedding.android.FlutterActivity
import android.app.NotificationChannel
import android.app.NotificationManager
import android.os.Build
import android.os.Bundle
import android.media.AudioAttributes
import android.media.RingtoneManager
import android.net.Uri
import android.app.Notification

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Android 8.0及以上需要手动创建通知通道
        // 创建通知通道
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channelId = "new_sound_channel"
            val channelName = "channelName"
            val channelDescription = "This is the default notification channel."
            val importance = NotificationManager.IMPORTANCE_HIGH
            val channel = NotificationChannel(channelId, channelName, importance).apply {
                description = channelDescription
                enableVibration(true) // 确保振动已启用
                setSound(
                    Uri.parse("android.resource://${packageName}/raw/notification_sound"),
                    AudioAttributes.Builder()
                        .setUsage(AudioAttributes.USAGE_NOTIFICATION)
                        .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                        .build()
                )
                setShowBadge(true) // 启用角标
                lockscreenVisibility = Notification.VISIBILITY_PUBLIC // 允许在锁屏显示
            }

            val notificationManager = getSystemService(NotificationManager::class.java)
            notificationManager.createNotificationChannel(channel)
        }
    }
}
