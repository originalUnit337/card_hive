import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/backup/domain/usecases/restore_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'restore_usecase_test.mocks.dart';

@GenerateMocks([BackupRepository])
void main() {
  late MockBackupRepository mockBackupRepository;
  late RestoreUseCase restoreUseCase;

  setUp(() {
    mockBackupRepository = MockBackupRepository();
    restoreUseCase = RestoreUseCase(mockBackupRepository);
  });

  test('should call restore on the repository', () async {
    // Arrange
    when(
      mockBackupRepository.restore(),
    ).thenAnswer((_) async => const DataSuccess(null));

    // Act
    final result = await restoreUseCase();

    // Assert
    expect(result, isA<DataSuccess>());
    verify(mockBackupRepository.restore());
    verifyNoMoreInteractions(mockBackupRepository);
  });
}
