import 'dart:convert';
import 'dart:ui';

import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:card_hive/features/backup/data/repository/backup_repository_impl.dart';
import 'package:card_hive/features/backup/domain/repositories/drive_remote_repository.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'backup_repository_impl_test.mocks.dart';

@GenerateMocks([DriveRemoteRepository, BackupAuthBridge])
void main() {
  late MockDriveRemoteRepository mockDriveRemoteRepository;
  late MockBackupAuthBridge mockBackupAuthBridge;
  late BackupRepositoryImpl backupRepository;

  setUp(() {
    mockDriveRemoteRepository = MockDriveRemoteRepository();
    mockBackupAuthBridge = MockBackupAuthBridge();
    backupRepository = BackupRepositoryImpl(
      mockDriveRemoteRepository,
      mockBackupAuthBridge,
    );
  });

  group('BackupRepositoryImpl', () {
    const tAccessToken = 'test_token';
    const tFileName = 'card_hive_backup.json';
    final tCards = [
      CardEntity(
        id: 1,
        name: 'Test Card',
        number: '12345',
        color: const Color(0xFFFFFFFF),
      ),
    ];
    final tDataToBackup = utf8.encode(
      jsonEncode(tCards.map((e) => e.toJson()).toList()),
    );

    group('backup', () {
      test('should return DataSuccess when backup is successful', () async {
        // Arrange
        when(
          mockBackupAuthBridge.getAccessTokenSilently(),
        ).thenAnswer((_) async => tAccessToken);
        when(
          mockDriveRemoteRepository.uploadBackup(any, any, any),
        ).thenAnswer((_) async => Future.value());

        // Act
        final result = await backupRepository.backup(tCards);

        // Assert
        expect(result, isA<DataSuccess>());
        verify(mockBackupAuthBridge.getAccessTokenSilently());
        verify(
          mockDriveRemoteRepository.uploadBackup(
            tAccessToken,
            tFileName,
            tDataToBackup,
          ),
        );
      });

      test('should return DataFailed when access token is null', () async {
        // Arrange
        when(
          mockBackupAuthBridge.getAccessTokenSilently(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await backupRepository.backup(tCards);

        // Assert
        expect(result, isA<DataFailed>());
        verify(mockBackupAuthBridge.getAccessTokenSilently());
        verifyNever(mockDriveRemoteRepository.uploadBackup(any, any, any));
      });

      test(
        'should return DataFailed when uploadBackup throws an exception',
        () async {
          // Arrange
          when(
            mockBackupAuthBridge.getAccessTokenSilently(),
          ).thenAnswer((_) async => tAccessToken);
          when(
            mockDriveRemoteRepository.uploadBackup(any, any, any),
          ).thenThrow(Exception('Test Exception'));

          // Act
          final result = await backupRepository.backup(tCards);

          // Assert
          expect(result, isA<DataFailed>());
          verify(mockBackupAuthBridge.getAccessTokenSilently());
          verify(
            mockDriveRemoteRepository.uploadBackup(
              tAccessToken,
              tFileName,
              tDataToBackup,
            ),
          );
        },
      );
    });

    group('getLastBackupTime', () {
      const tFileId = 'test_file_id';
      final tLastModified = DateTime.now();

      test(
        'should return DataSuccess with DateTime when backup file exists',
        () async {
          // Arrange
          when(
            mockBackupAuthBridge.getAccessTokenSilently(),
          ).thenAnswer((_) async => tAccessToken);
          when(
            mockDriveRemoteRepository.findBackupFileId(any, any),
          ).thenAnswer((_) async => tFileId);
          when(
            mockDriveRemoteRepository.getFileModifiedTime(any, any),
          ).thenAnswer((_) async => tLastModified);

          // Act
          final result = await backupRepository.getLastBackupTime();

          // Assert
          expect(result, isA<DataSuccess<DateTime?>>());
          expect(result.data, tLastModified);
          verify(mockBackupAuthBridge.getAccessTokenSilently());
          verify(
            mockDriveRemoteRepository.findBackupFileId(tAccessToken, tFileName),
          );
          verify(
            mockDriveRemoteRepository.getFileModifiedTime(
              tAccessToken,
              tFileId,
            ),
          );
        },
      );

      test(
        'should return DataSuccess with null when backup file does not exist',
        () async {
          // Arrange
          when(
            mockBackupAuthBridge.getAccessTokenSilently(),
          ).thenAnswer((_) async => tAccessToken);
          when(
            mockDriveRemoteRepository.findBackupFileId(any, any),
          ).thenAnswer((_) async => null);

          // Act
          final result = await backupRepository.getLastBackupTime();

          // Assert
          expect(result, isA<DataSuccess<DateTime?>>());
          expect(result.data, null);
          verify(mockBackupAuthBridge.getAccessTokenSilently());
          verify(
            mockDriveRemoteRepository.findBackupFileId(tAccessToken, tFileName),
          );
          verifyNever(mockDriveRemoteRepository.getFileModifiedTime(any, any));
        },
      );

      test('should return DataFailed when access token is null', () async {
        // Arrange
        when(
          mockBackupAuthBridge.getAccessTokenSilently(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await backupRepository.getLastBackupTime();

        // Assert
        expect(result, isA<DataFailed>());
        verify(mockBackupAuthBridge.getAccessTokenSilently());
        verifyNever(mockDriveRemoteRepository.findBackupFileId(any, any));
        verifyNever(mockDriveRemoteRepository.getFileModifiedTime(any, any));
      });
    });

    group('restore', () {
      const tFileId = 'test_file_id';

      test('should return DataSuccess when restore is successful', () async {
        // Arrange
        when(
          mockBackupAuthBridge.getAccessTokenSilently(),
        ).thenAnswer((_) async => tAccessToken);
        when(
          mockDriveRemoteRepository.findBackupFileId(any, any),
        ).thenAnswer((_) async => tFileId);
        when(
          mockDriveRemoteRepository.downloadBackup(any, any),
        ).thenAnswer((_) async => tDataToBackup);

        // Act
        final result = await backupRepository.restore();

        // Assert
        expect(result, isA<DataSuccess>());
        verify(mockBackupAuthBridge.getAccessTokenSilently());
        verify(
          mockDriveRemoteRepository.findBackupFileId(tAccessToken, tFileName),
        );
        verify(mockDriveRemoteRepository.downloadBackup(tAccessToken, tFileId));
      });

      test(
        'should return DataFailed when backup file does not exist',
        () async {
          // Arrange
          when(
            mockBackupAuthBridge.getAccessTokenSilently(),
          ).thenAnswer((_) async => tAccessToken);
          when(
            mockDriveRemoteRepository.findBackupFileId(any, any),
          ).thenAnswer((_) async => null);

          // Act
          final result = await backupRepository.restore();

          // Assert
          expect(result, isA<DataFailed>());
          verify(mockBackupAuthBridge.getAccessTokenSilently());
          verify(
            mockDriveRemoteRepository.findBackupFileId(tAccessToken, tFileName),
          );
          verifyNever(mockDriveRemoteRepository.downloadBackup(any, any));
        },
      );

      test('should return DataFailed when access token is null', () async {
        // Arrange
        when(
          mockBackupAuthBridge.getAccessTokenSilently(),
        ).thenAnswer((_) async => null);

        // Act
        final result = await backupRepository.restore();

        // Assert
        expect(result, isA<DataFailed>());
        verify(mockBackupAuthBridge.getAccessTokenSilently());
        verifyNever(mockDriveRemoteRepository.findBackupFileId(any, any));
        verifyNever(mockDriveRemoteRepository.downloadBackup(any, any));
      });
    });
  });
}
