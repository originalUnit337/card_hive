import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';

class RestoreUseCase implements UseCase<DataState<List<CardEntity>>, void> {
  final BackupRepository _backupRepository;

  RestoreUseCase(this._backupRepository);

  @override
  Future<DataState<List<CardEntity>>> call({void params}) {
    return _backupRepository.restore();
  }
}
