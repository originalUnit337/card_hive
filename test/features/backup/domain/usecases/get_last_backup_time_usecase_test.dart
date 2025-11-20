import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/backup/domain/usecases/get_last_backup_time_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_last_backup_time_usecase_test.mocks.dart';

@GenerateMocks([BackupRepository])
void main() {
  late MockBackupRepository mockBackupRepository;
  late GetLastBackupTimeUseCase getLastBackupTimeUseCase;

  setUp(() {
    mockBackupRepository = MockBackupRepository();
    getLastBackupTimeUseCase = GetLastBackupTimeUseCase(mockBackupRepository);
  });

  final tLastBackupTime = DateTime.now();

  test('should get last backup time from the repository', () async {
    // Arrange
    when(
      mockBackupRepository.getLastBackupTime(),
    ).thenAnswer((_) async => DataSuccess(tLastBackupTime));

    // Act
    final result = await getLastBackupTimeUseCase();

    // Assert
    expect(result, isA<DataSuccess>());
    expect(result.data, tLastBackupTime);
    verify(mockBackupRepository.getLastBackupTime());
    verifyNoMoreInteractions(mockBackupRepository);
  });
}
