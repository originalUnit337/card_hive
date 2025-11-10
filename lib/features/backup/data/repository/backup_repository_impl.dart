import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/backup/domain/repositories/drive_remote_repository.dart';
import 'package:logger/logger.dart'; // Import Logger

class BackupRepositoryImpl implements BackupRepository {
  final DriveRemoteRepository _driveRemoteRepository;
  final BackupAuthBridge _googleAuthDatasource;
  final Logger _logger = Logger(); // Initialize Logger

  BackupRepositoryImpl(this._driveRemoteRepository, this._googleAuthDatasource);

  @override
  Future<DataState<void>> backup() async {
    try {
      final accessToken = await _googleAuthDatasource.getAccessTokenSilently();
      if (accessToken == null) {
        _logger.e('Backup failed: Access token not available.');
        return DataFailed(Exception('Access token not available.'));
      }

      // TODO: Get actual data to backup (e.g., from ObjectBox)
      final List<int> dataToBackup = []; // Placeholder for actual data
      const String fileName =
          'card_hive_backup.json'; // Placeholder for file name

      await _driveRemoteRepository.uploadBackup(
        accessToken,
        fileName,
        dataToBackup,
      );
      return const DataSuccess(null);
    } catch (e, st) {
      _logger.e('Error during backup: $e', error: e, stackTrace: st);
      return DataFailed(Exception('Failed to backup data: $e'));
    }
  }

  @override
  Future<DataState<DateTime?>> getLastBackupTime() async {
    try {
      final accessToken = await _googleAuthDatasource.getAccessTokenSilently();
      if (accessToken == null) {
        _logger.e('Get last backup time failed: Access token not available.');
        return DataFailed(Exception('Access token not available.'));
      }

      const String fileName =
          'card_hive_backup.json'; // Placeholder for file name
      final fileId = await _driveRemoteRepository.findBackupFileId(
        accessToken,
        fileName,
      );

      if (fileId == null) {
        return const DataSuccess(null); // No backup found
      }

      final lastModified = await _driveRemoteRepository.getFileModifiedTime(
        accessToken,
        fileId,
      );
      return DataSuccess(lastModified);
    } catch (e, st) {
      _logger.e('Error getting last backup time: $e', error: e, stackTrace: st);
      return DataFailed(Exception('Failed to get last backup time: $e'));
    }
  }

  @override
  Future<DataState<void>> restore() async {
    try {
      final accessToken = await _googleAuthDatasource.getAccessTokenSilently();
      if (accessToken == null) {
        _logger.e('Restore failed: Access token not available.');
        return DataFailed(Exception('Access token not available.'));
      }

      const String fileName =
          'card_hive_backup.json'; // Placeholder for file name
      final fileId = await _driveRemoteRepository.findBackupFileId(
        accessToken,
        fileName,
      );

      if (fileId == null) {
        _logger.i('No backup file found to restore.');
        return DataFailed(Exception('No backup file found.'));
      }

      final backupData = await _driveRemoteRepository.downloadBackup(
        accessToken,
        fileId,
      );
      // TODO: Implement actual restoration logic with backupData
      _logger.i(
        'Backup data downloaded successfully. Size: ${backupData.length} bytes',
      );
      return const DataSuccess(null);
    } catch (e, st) {
      _logger.e('Error during restore: $e', error: e, stackTrace: st);
      return DataFailed(Exception('Failed to restore data: $e'));
    }
  }
}
