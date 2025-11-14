import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

class BackupUseCase implements UseCase<DataState<void>, List<CardEntity>> {
  final BackupRepository _backupRepository;

  BackupUseCase(this._backupRepository);

  @override
  Future<DataState<void>> call({required List<CardEntity> params}) {
    return _backupRepository.backup(params);
  }
}
