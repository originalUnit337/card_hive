import 'dart:ui';

import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/backup/domain/usecases/backup_usecase.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'backup_usecase_test.mocks.dart';

@GenerateMocks([BackupRepository])
void main() {
  late MockBackupRepository mockBackupRepository;
  late BackupUseCase backupUseCase;

  setUp(() {
    mockBackupRepository = MockBackupRepository();
    backupUseCase = BackupUseCase(mockBackupRepository);
  });

  final tCards = [
    CardEntity(
      id: 1,
      name: 'Test Card',
      number: '12345',
      color: const Color(0xFFFFFFFF),
    ),
  ];

  test('should call backup on the repository', () async {
    // Arrange
    when(
      mockBackupRepository.backup(any),
    ).thenAnswer((_) async => const DataSuccess(null));

    // Act
    final result = await backupUseCase(params: tCards);

    // Assert
    expect(result, isA<DataSuccess>());
    verify(mockBackupRepository.backup(tCards));
    verifyNoMoreInteractions(mockBackupRepository);
  });
}
