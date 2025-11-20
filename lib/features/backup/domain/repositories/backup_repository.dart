import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

abstract class BackupRepository {
  Future<DataState<void>> backup(List<CardEntity> cards);
  Future<DataState<List<CardEntity>>> restore();
  Future<DataState<DateTime?>> getLastBackupTime();
}
