abstract class BackupRepository {
  Future<void> backup();
  Future<void> restore();
  Future<DateTime?> getLastBackupTime();
}
