import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Notifikasi lokal (immediate notification).
/// Dipakai saat sebuah spell dihapus dari daftar favorit.
final FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  await notificationsPlugin.initialize(settings: initSettings);

  await notificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
}

Future<void> showSpellDeletedNotification(String spellName) async {
  const androidDetails = AndroidNotificationDetails(
    'favorite_spells_channel',
    'Favorite Spell',
    channelDescription: 'Notifikasi untuk spell favorite',
    importance: Importance.max,
    priority: Priority.high,
  );
  const details = NotificationDetails(android: androidDetails);

  await notificationsPlugin.show(
    id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    title: 'Delete notification',
    body: 'You deleted $spellName from your fav list!',
    notificationDetails: details,
  );
}
