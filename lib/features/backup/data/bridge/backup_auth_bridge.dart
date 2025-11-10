abstract class BackupAuthBridge {
  Future<String?> getAccessTokenSilently();
  /// Выполняет интерактивный вход в контексте user gesture; возвращает true при успехе.
  Future<bool> interactiveSignIn();
  Future<void> signOut();
}
