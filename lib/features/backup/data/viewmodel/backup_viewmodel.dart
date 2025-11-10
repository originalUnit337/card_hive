import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:flutter/foundation.dart';

class BackupViewModel extends ChangeNotifier {
  final BackupAuthBridge authBridge;
  bool loading = false;
  String? token;

  BackupViewModel(this.authBridge);

  Future<void> init() async {
    loading = true; notifyListeners();
    token = await authBridge.getAccessTokenSilently();
    loading = false; notifyListeners();
  }

  Future<bool> ensureSignedIn() async {
    token = await authBridge.getAccessTokenSilently();
    if (token != null) return true;
    // вызывает интерактивный flow — должен быть user gesture, поэтому Presentation карточки вызовет этот метод при нажатии
    final ok = await authBridge.interactiveSignIn();
    if (ok) token = await authBridge.getAccessTokenSilently();
    notifyListeners();
    return token != null;
  }

  Future<void> backup() async {
    if (!await ensureSignedIn()) throw Exception('NEED_SIGN_IN');
    // вызвать UseCase backup
  }
}
