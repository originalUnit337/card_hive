import 'package:card_hive/features/backup/domain/repositories/drive_remote_repository.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class GoogleHttpClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleHttpClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class DriveRemoteService implements DriveRemoteRepository {
  final Logger _logger = Logger();

  DriveRemoteService();

  drive.DriveApi? _driveApi;

  Future<drive.DriveApi?> _getDriveApi(String accessToken) async {
    if (_driveApi == null) {
      final headers = {'Authorization': 'Bearer $accessToken'};
      final authenticatedClient = GoogleHttpClient(headers);
      _driveApi = drive.DriveApi(authenticatedClient);
    }
    return _driveApi;
  }

  @override
  Future<void> uploadBackup(
    String accessToken,
    String fileName,
    List<int> bytes,
  ) async {
    try {
      final driveApi = await _getDriveApi(accessToken);
      if (driveApi == null) {
        _logger.e('Drive API not available for upload.');
        return;
      }

      // Find existing backup file
      final existingFileId = await findBackupFileId(accessToken, fileName);

      final drive.File fileMetadata = drive.File();
      fileMetadata.name = fileName;
      fileMetadata.parents = ['appDataFolder']; // Store in app-specific folder

      final media = drive.Media(
        Stream.fromIterable([bytes]),
        bytes.length,
        contentType: 'application/json',
      );

      if (existingFileId != null) {
        // Update existing file
        await driveApi.files.update(
          fileMetadata,
          existingFileId,
          uploadMedia: media,
        );
        _logger.i('Backup file updated successfully: $fileName');
      } else {
        // Create new file
        await driveApi.files.create(fileMetadata, uploadMedia: media);
        _logger.i('Backup file created successfully: $fileName');
      }
    } catch (e, st) {
      _logger.e('Error uploading backup: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<int>> downloadBackup(String accessToken, String fileId) async {
    try {
      final driveApi = await _getDriveApi(accessToken);
      if (driveApi == null) {
        _logger.e('Drive API not available for download.');
        return [];
      }

      final mediaFile =
          await driveApi.files.get(
                fileId,
                downloadOptions: drive.DownloadOptions.fullMedia,
              )
              as drive.Media;

      final List<int> data = [];
      await for (var chunk in mediaFile.stream) {
        data.addAll(chunk);
      }
      _logger.i(
        'Backup file downloaded successfully. Size: ${data.length} bytes',
      );
      return data;
    } catch (e, st) {
      _logger.e('Error downloading backup: $e', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<String?> findBackupFileId(String accessToken, String fileName) async {
    try {
      final driveApi = await _getDriveApi(accessToken);
      if (driveApi == null) {
        _logger.e('Drive API not available for finding file ID.');
        return null;
      }

      final fileList = await driveApi.files.list(
        q: "name = '$fileName' and 'appDataFolder' in parents",
        $fields: 'files(id, name)',
      );

      return fileList.files?.firstWhere((file) => file.name == fileName).id;
    } catch (e, st) {
      _logger.e('Error finding backup file ID: $e', error: e, stackTrace: st);
      return null;
    }
  }

  @override
  Future<DateTime?> getFileModifiedTime(
    String accessToken,
    String fileId,
  ) async {
    try {
      final driveApi = await _getDriveApi(accessToken);
      if (driveApi == null) {
        _logger.e('Drive API not available for getting file modified time.');
        return null;
      }

      final file =
          await driveApi.files.get(fileId, $fields: 'modifiedTime')
              as drive.File;
      return file.modifiedTime;
    } catch (e, st) {
      _logger.e(
        'Error getting file modified time: $e',
        error: e,
        stackTrace: st,
      );
      return null;
    }
  }
}
