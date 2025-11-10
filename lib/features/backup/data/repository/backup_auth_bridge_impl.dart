import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

class BackupAuthBridgeImpl implements BackupAuthBridge {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  final FlutterSecureStorage _secureStorage;
  static const _kTokenKey = 'backup_access_token';

  BackupAuthBridgeImpl(this._secureStorage);

  Future<void> initialize({String? clientId, String? serverClientId}) =>
      _googleSignIn.initialize(clientId: clientId, serverClientId: serverClientId);

  @override
  Future<String?> getAccessTokenSilently() async {
    final cached = await _secureStorage.read(key: _kTokenKey);
    if (cached != null) return cached;


    try {
      final account = await _googleSignIn.attemptLightweightAuthentication();
      if (account == null) return null;
      final googleAuthorization = await account.authorizationClient.authorizeScopes(
        //TODO: Change to .../drive.appdata
        const ['https://www.googleapis.com/auth/drive.file'],
      );
      final token = googleAuthorization?.accessToken;
      if (token != null) await _secureStorage.write(key: _kTokenKey, value: token);
      return token;
    } catch (e, st) {
      Logger().e('ERROR geting access token silently: ', error: e, stackTrace: st);
    }
    return null;
  }

  @override
  Future<bool> interactiveSignIn() async {
    try {
      final account = await _googleSignIn.authenticate(
        scopeHint: const ['https://www.googleapis.com/auth/drive.file'],
      );
      if (account == null) {
        return false;
      }
      final googleAuthorization = await account.authorizationClient.authorizeScopes(
        const ['https://www.googleapis.com/auth/drive.file'],
      );
      final token = googleAuthorization?.accessToken;
      if (token != null) {
        await _secureStorage.write(key: _kTokenKey, value: token);
        return true;
      }
      return false;
    } catch (e, st) {
      Logger().e('ERROR interactive sign in: ', error: e, stackTrace: st);
      return false;
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _secureStorage.delete(key: _kTokenKey);
  }
}
