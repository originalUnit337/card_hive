abstract class DriveRemoteRepository {
  Future<void> uploadBackup(
    String accessToken,
    String fileName,
    List<int> bytes,
  );
  Future<List<int>> downloadBackup(String accessToken, String fileId);
  Future<String?> findBackupFileId(String accessToken, String fileName);
  Future<DateTime?> getFileModifiedTime(String accessToken, String fileId);
}
