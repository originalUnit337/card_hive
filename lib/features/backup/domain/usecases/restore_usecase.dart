import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';

class RestoreUseCase extends UseCase<void, void> {
  final BackupRepository _backupRepository;

  RestoreUseCase(this._backupRepository);

  @override
  Future<void> call({void params}) {
    return _backupRepository.restore();
  }
}
