import 'package:matrix/matrix.dart';

import 'package:matrix_echo_bot/answer_messages.dart';
import 'package:matrix_echo_bot/config.dart';

extension ConnectStreams on Client {
  void connectChatGPTStreams(BotConfig config) {
    onTimelineEvent.stream
        .where((event) =>
            event.type == EventTypes.Message &&
            event.messageType == MessageTypes.Text &&
            event.senderId != userID)
        .listen(
          (event) => answerMessage(
            event,
            config,
          ),
        );

    onNotification.stream
        .where((event) => event.room.membership == Membership.invite)
        .listen(
      (event) {
        final sender = event.senderId;
        Logs().i('Received invite from $sender');
        if (!config.allowList
            .any((allowRegex) => RegExp(allowRegex).hasMatch(sender))) {
          Logs().w('$sender is not in allow list! Ignoring invite.');
          return;
        }
        event.room.join();
      },
    );
    final welcomeMessage = config.welcomeMessage;
    if (welcomeMessage != null) {
      onSync.stream
          .map((syncUpdate) => syncUpdate.deviceLists?.changed)
          .where((list) => list?.isNotEmpty ?? false)
          .listen((userIds) async {
        await Future.delayed(const Duration(seconds: 10));
        for (final userId in userIds!) {
          if (!config.allowList.contains(userId)) continue;

          final dmRooms =
              directChats[userId]?.map(getRoomById).whereType<Room>();
          if (dmRooms == null || dmRooms.isEmpty) continue;
          for (final room in dmRooms) {
            await room.sendTextEvent(welcomeMessage);
          }
        }
      });
    }
  }
}
