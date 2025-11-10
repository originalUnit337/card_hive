import 'package:card_hive/core/resources/data_state.dart';

abstract class BackupRepository {
  Future<DataState<void>> backup();
  Future<DataState<void>> restore();
  Future<DataState<DateTime?>> getLastBackupTime();
}
