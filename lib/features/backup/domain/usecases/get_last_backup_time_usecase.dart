import 'package:card_hive/core/usecase/usecase.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';

class GetLastBackupTimeUseCase extends UseCase<DateTime?, void> {
  final BackupRepository _backupRepository;

  GetLastBackupTimeUseCase(this._backupRepository);

  @override
  Future<DateTime?> call({void params}) {
    return _backupRepository.getLastBackupTime();
  }
}
