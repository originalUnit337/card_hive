import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';

class BackupUseCase implements UseCase<DataState<void>, void> {
  final BackupRepository _backupRepository;

  BackupUseCase(this._backupRepository);

  @override
  Future<DataState<void>> call({void params}) {
    return _backupRepository.backup();
  }
}
