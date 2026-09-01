import 'dart:async';

import 'package:matrix/encryption.dart';
import 'package:matrix/matrix.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:vodozemac/vodozemac.dart' as vod;

import 'package:matrix_echo_bot/config.dart';

Future<Client> connectMatrixClient(BotConfig config) async {
  await vod.init(libraryPath: './vod/release/');
  final client = Client(
    'matrix_echo_bot',
    database: await MatrixSdkDatabase.init(
      'matrix_echo_bot',
      database: await databaseFactoryFfi.openDatabase('./matrix.sqlite'),
      sqfliteFactory: databaseFactoryFfi,
    ),
    logLevel: config.logLevel,
    shareKeysWith: ShareKeysWith.all,
  );
  client.syncPresence = PresenceType.offline;

  await client.init();

  if (!client.isLogged()) {
    await client.checkHomeserver(Uri.parse(config.homeserver));

    await client.login(
      config.password != null
          ? LoginType.mLoginPassword
          : 'com.famedly.login.token.oidc',
      identifier: AuthenticationUserIdentifier(user: config.matrixId),
      password: config.password,
      token: config.accessToken,
    );

    final passphrase = config.passphrase;

    if (passphrase != null) {
      final cryptoState = await client.getCryptoIdentityState();
      if (cryptoState.initialized) {
        try {
          await client.restoreCryptoIdentity(passphrase);
        } catch (e, s) {
          Logs().e('Unable to restore crypto identity. Resetting...', e, s);
          await client.initCryptoIdentity(passphrase: passphrase);
        }
      } else {
        await client.initCryptoIdentity(passphrase: passphrase);
      }
    }
  }

  return client;
}
