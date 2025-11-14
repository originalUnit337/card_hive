import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:equatable/equatable.dart';

sealed class BackupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class BackupInitial extends BackupState {}

class BackupLoading extends BackupState {}

class BackupSignedOut extends BackupState {}

class BackupSignedIn extends BackupState {}

class BackupSuccess extends BackupState {}

class BackupFailure extends BackupState {
  final Exception? exception;
  BackupFailure(this.exception);

  @override
  List<Object?> get props => [exception.toString()];
}

class BackupNeedInteractiveSignIn extends BackupState {
  final List<CardEntity> cards;
  BackupNeedInteractiveSignIn(this.cards);

  @override
  List<Object?> get props => [cards];
}
