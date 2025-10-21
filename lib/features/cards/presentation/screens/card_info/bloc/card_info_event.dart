import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:equatable/equatable.dart';

sealed class CardInfoEvent extends Equatable {
  const CardInfoEvent();

  @override
  List<Object?> get props => [];
}

class SaveCardEvent extends CardInfoEvent {
  final CardEntity card;
  const SaveCardEvent(this.card);
}

class DeleteCardEvent extends CardInfoEvent {
  final CardEntity card;
  const DeleteCardEvent(this.card);
}

class RemoveCardEvent extends CardInfoEvent {
  final int id;
  const RemoveCardEvent(this.id);
}

/// Used to force CardInfoBloc to set initial state
class ResetCardEvent extends CardInfoEvent {
  const ResetCardEvent();
}
