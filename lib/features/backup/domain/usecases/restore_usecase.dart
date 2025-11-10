import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';

class RestoreUseCase implements UseCase<DataState<void>, void> {
  final BackupRepository _backupRepository;

  RestoreUseCase(this._backupRepository);

  @override
  Future<DataState<void>> call({void params}) {
    return _backupRepository.restore();
  }
}
