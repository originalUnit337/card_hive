// sealed class BackupState { initial, loading, signedOut, signedIn, backupSuccess, backupFailure, needInteractiveSignIn }
sealed class BackupState {

}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {}

class BackupSignedOut extends BackupState {}

class BackupSignedIn extends BackupState {}

class BackupSuccess extends BackupState {}

class BackupFailure extends BackupState {
  final Exception? exception;
  BackupFailure(this.exception);
}

class BackupNeedInteractiveSignIn extends BackupState {}
