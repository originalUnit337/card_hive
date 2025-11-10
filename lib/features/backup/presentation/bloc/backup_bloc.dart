import 'package:bloc/bloc.dart';
import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:card_hive/features/backup/domain/usecases/backup_usecase.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_event.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_state.dart';


class BackupBloc extends Bloc<BackupEvent, BackupState> {
  final BackupAuthBridge authBridge;
  final BackupUseCase backupUseCase;

  BackupBloc({required this.authBridge, required this.backupUseCase}) : super(BackupInitial()) {
    on<BackupInit>(_onInit);
    on<BackupTry>(_onTryBackup);
    on<BackupInteractiveSignIn>(_onInteractiveSignIn);
    on<BackupSignOut>(_onSignOut);
  }

  Future<void> _onInit(BackupInit e, Emitter<BackupState> emit) async {
    emit(BackupLoading());
    final token = await authBridge.getAccessTokenSilently();
    if (token != null) {
      emit(BackupSignedIn());
    } else {
      emit(BackupSignedOut());
    }
  }

  Future<void> _onTryBackup(BackupTry e, Emitter<BackupState> emit) async {
    emit(BackupLoading());
    final token = await authBridge.getAccessTokenSilently();
    if (token == null) {
      emit(BackupNeedInteractiveSignIn());
      return;
    }
    final result = await backupUseCase.call();
    if (result is DataSuccess) {
      emit(BackupSuccess());
    } else {
      emit(BackupFailure((result as DataFailed).exception));
    }
  }

  Future<void> _onInteractiveSignIn(BackupInteractiveSignIn e, Emitter<BackupState> emit) async {
    emit(BackupLoading());
    final ok = await authBridge.interactiveSignIn(); // called from user gesture
    if (!ok) {
      emit(BackupSignedOut());
      return;
    }
    final token = await authBridge.getAccessTokenSilently();
    if (token == null) {
      emit(BackupSignedOut());
      return;
    }
    // после успешного входа можно запустить бэкап автоматически или ждать явного события
    if (e.runBackupAfterSignIn) {
      add(BackupTry());
    } else {
      emit(BackupSignedIn());
    }
  }

  Future<void> _onSignOut(BackupSignOut e, Emitter<BackupState> emit) async {
    await authBridge.signOut();
    emit(BackupSignedOut());
  }
}
