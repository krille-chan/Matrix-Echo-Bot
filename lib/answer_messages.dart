import 'package:matrix/matrix.dart' hide Role;

import 'package:matrix_echo_bot/config.dart';

void answerMessage(Event event, BotConfig config) async {
  try {
    if (event.messageType != MessageTypes.Text) return;
    Logs().i('Received new message from ${event.senderId}');
    if (!config.allowList
        .any((allowRegex) => RegExp(allowRegex).hasMatch(event.senderId))) {
      Logs().w('${event.senderId} is not in allow list! Ignoring message.');
      return;
    }

    event.room.client.syncPresence = PresenceType.online;

    final firstWord = event.body.trim().split(' ').first.toLowerCase();
    if (firstWord == 'help') {
      await event.room.sendTextEvent(
          config.welcomeMessage ?? 'No welcome message specified');
    } else {
      final number = int.tryParse(firstWord);
      if (number != null) {
        await event.room.setTyping(true);
        await Future.delayed(Duration(seconds: number));
        await event.room.setTyping(false);
      }
      await event.room.sendTextEvent(event.body);
    }
  } catch (e, s) {
    await event.room.sendTextEvent('Unexpected error occurded:\n$e\n\n$s');
  } finally {
    event.room.client.syncPresence = PresenceType.offline;
  }
}
