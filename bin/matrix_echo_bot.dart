import 'package:matrix/matrix.dart';

import 'package:matrix_echo_bot/config.dart';
import 'package:matrix_echo_bot/connect_matrix_client.dart';
import 'package:matrix_echo_bot/connect_streams.dart';

void main(List<String> arguments) async {
  final config = BotConfig.fromFile(arguments.singleOrNull ?? './config.json');

  final client = await connectMatrixClient(config);
  Logs().level = Level.verbose;
  client.connectChatGPTStreams(config);

  Logs().i(
    'Matrix Echo Bot started with this configuration',
    arguments.singleOrNull ?? './config.json',
  );
}
