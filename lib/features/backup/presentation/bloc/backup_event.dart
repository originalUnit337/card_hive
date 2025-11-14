// События: BackupEvent { Init, TryBackup, InteractiveSignInRequested, SignOut }
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

sealed class BackupEvent {}

class BackupInit extends BackupEvent {}

class BackupTry extends BackupEvent {
  List<CardEntity> cards;
  BackupTry(this.cards);
}

class BackupRestore extends BackupEvent {}

class BackupInteractiveSignIn extends BackupEvent {
  final List<CardEntity> cards;
  final bool runBackupAfterSignIn;
  BackupInteractiveSignIn({
    required this.cards,
    this.runBackupAfterSignIn = true,
  });
}

class BackupSignOut extends BackupEvent {}
