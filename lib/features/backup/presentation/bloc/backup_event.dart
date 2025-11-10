// События: BackupEvent { Init, TryBackup, InteractiveSignInRequested, SignOut }
sealed class BackupEvent {}

class BackupInit extends BackupEvent {}

class BackupTry extends BackupEvent {}

class BackupInteractiveSignIn extends BackupEvent {final bool runBackupAfterSignIn;
  BackupInteractiveSignIn({this.runBackupAfterSignIn = true});}

class BackupSignOut extends BackupEvent {}
