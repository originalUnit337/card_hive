abstract class BackupAuthBridge {
  Future<String?> getAccessTokenSilently();
  Future<bool> interactiveSignIn();
  Future<void> signOut();
}
