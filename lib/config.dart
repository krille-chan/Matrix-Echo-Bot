import 'dart:convert';
import 'dart:io';

import 'package:matrix/matrix.dart';

class BotConfig {
  final String matrixId;
  final String? password;
  final String? accessToken;
  final String homeserver;
  final String? passphrase;
  final Level logLevel;
  final List<String> allowList;
  final String? welcomeMessage;

  const BotConfig({
    required this.matrixId,
    required this.password,
    required this.homeserver,
    required this.logLevel,
    required this.allowList,
    required this.passphrase,
    required this.accessToken,
    required this.welcomeMessage,
  });

  factory BotConfig.fromJson(Map json) => BotConfig(
        matrixId: json['matrixId'],
        password: json['password'],
        homeserver: json['homeserver'],
        logLevel: Level.values.singleWhere(
          (l) => l.name == (json['logLevel'] ?? 'info'),
        ),
        allowList: List<String>.from(json['allowList']),
        passphrase: json['passphrase'],
        accessToken: json['accessToken'],
        welcomeMessage: json['welcomeMessage'],
      );

  factory BotConfig.fromFile(String path) {
    final file = File(path);
    final jsonStr = file.readAsStringSync();
    final json = jsonDecode(jsonStr);
    return BotConfig.fromJson(json);
  }
}
