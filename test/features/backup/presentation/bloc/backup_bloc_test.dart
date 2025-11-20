import 'dart:ui';

import 'package:bloc_test/bloc_test.dart';
import 'package:card_hive/core/resources/data_state.dart';
import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:card_hive/features/backup/domain/usecases/backup_usecase.dart';
import 'package:card_hive/features/backup/domain/usecases/restore_usecase.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_event.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'backup_bloc_test.mocks.dart';

@GenerateMocks([BackupAuthBridge, BackupUseCase, RestoreUseCase])
void main() {
  late MockBackupAuthBridge mockBackupAuthBridge;
  late MockBackupUseCase mockBackupUseCase;
  late MockRestoreUseCase mockRestoreUseCase;
  late BackupBloc backupBloc;

  setUp(() {
    mockBackupAuthBridge = MockBackupAuthBridge();
    mockBackupUseCase = MockBackupUseCase();
    mockRestoreUseCase = MockRestoreUseCase();
    backupBloc = BackupBloc(
      authBridge: mockBackupAuthBridge,
      backupUseCase: mockBackupUseCase,
      restoreUseCase: mockRestoreUseCase,
    );
  });

  tearDown(() {
    backupBloc.close();
  });

  final tCards = [
    CardEntity(
      id: 1,
      name: 'Test Card',
      number: '12345',
      color: const Color(0xFFFFFFFF),
    )
  ];

  group('BackupBloc', () {
    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSignedIn] when BackupInit is added and token is available',
      build: () {
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => 'test_token');
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupInit()),
      expect: () => [
        BackupLoading(),
        BackupSignedIn(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSignedOut] when BackupInit is added and token is null',
      build: () {
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => null);
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupInit()),
      expect: () => [
        BackupLoading(),
        BackupSignedOut(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSuccess] when BackupTry is added and backup is successful',
      build: () {
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => 'test_token');
        when(mockBackupUseCase.call(params: tCards))
            .thenAnswer((_) async => const DataSuccess(null));
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupTry(tCards)),
      expect: () => [
        BackupLoading(),
        BackupSuccess(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
        verify(mockBackupUseCase.call(params: tCards)).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupNeedInteractiveSignIn] when BackupTry is added and token is null',
      build: () {
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => null);
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupTry(tCards)),
      expect: () => [
        BackupLoading(),
        BackupNeedInteractiveSignIn(tCards),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
        verifyZeroInteractions(mockBackupUseCase);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupFailure] when BackupTry is added and backup fails',
      build: () {
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => 'test_token');
        when(mockBackupUseCase.call(params: tCards))
            .thenAnswer((_) async => DataFailed(Exception()));
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupTry(tCards)),
      expect: () => [
        BackupLoading(),
        BackupFailure(Exception()),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
        verify(mockBackupUseCase.call(params: tCards)).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSuccess] when BackupRestore is added and restore is successful',
      build: () {
        when(mockRestoreUseCase.call())
            .thenAnswer((_) async => const DataSuccess(null));
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupRestore()),
      expect: () => [
        BackupLoading(),
        BackupSuccess(),
      ],
      verify: (_) {
        verify(mockRestoreUseCase.call()).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupFailure] when BackupRestore is added and restore fails',
      build: () {
        when(mockRestoreUseCase.call())
            .thenAnswer((_) async => DataFailed(Exception()));
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupRestore()),
      expect: () => [
        BackupLoading(),
        BackupFailure(Exception()),
      ],
      verify: (_) {
        verify(mockRestoreUseCase.call()).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSignedIn] when BackupInteractiveSignIn is successful and runBackupAfterSignIn is false',
      build: () {
        when(mockBackupAuthBridge.interactiveSignIn())
            .thenAnswer((_) async => true);
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => 'test_token');
        return backupBloc;
      },
      act: (bloc) => bloc.add(
          BackupInteractiveSignIn(cards: tCards, runBackupAfterSignIn: false)),
      expect: () => [
        BackupLoading(),
        BackupSignedIn(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.interactiveSignIn()).called(1);
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
        verifyZeroInteractions(mockBackupUseCase);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSignedOut] when BackupInteractiveSignIn fails',
      build: () {
        when(mockBackupAuthBridge.interactiveSignIn())
            .thenAnswer((_) async => false);
        return backupBloc;
      },
      act: (bloc) => bloc.add(
          BackupInteractiveSignIn(cards: tCards, runBackupAfterSignIn: false)),
      expect: () => [
        BackupLoading(),
        BackupSignedOut(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.interactiveSignIn()).called(1);
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(0);
        verifyZeroInteractions(mockBackupUseCase);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSignedOut] when BackupInteractiveSignIn is successful but token is null',
      build: () {
        when(mockBackupAuthBridge.interactiveSignIn())
            .thenAnswer((_) async => true);
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => null);
        return backupBloc;
      },
      act: (bloc) => bloc.add(
          BackupInteractiveSignIn(cards: tCards, runBackupAfterSignIn: false)),
      expect: () => [
        BackupLoading(),
        BackupSignedOut(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.interactiveSignIn()).called(1);
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
        verifyZeroInteractions(mockBackupUseCase);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupLoading, BackupSignedIn, BackupLoading, BackupSuccess] when BackupInteractiveSignIn is successful and runBackupAfterSignIn is true',
      build: () {
        when(mockBackupAuthBridge.interactiveSignIn())
            .thenAnswer((_) async => true);
        when(mockBackupAuthBridge.getAccessTokenSilently())
            .thenAnswer((_) async => 'test_token');
        when(mockBackupUseCase.call(params: tCards))
            .thenAnswer((_) async => const DataSuccess(null));
        return backupBloc;
      },
      act: (bloc) => bloc
          .add(BackupInteractiveSignIn(cards: tCards, runBackupAfterSignIn: true)),
      expect: () => [
        BackupLoading(),
        BackupSignedIn(),
        BackupLoading(),
        BackupSuccess(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.interactiveSignIn()).called(1);
        verify(mockBackupAuthBridge.getAccessTokenSilently()).called(1);
        verify(mockBackupUseCase.call(params: tCards)).called(1);
      },
    );

    blocTest<BackupBloc, BackupState>(
      'emits [BackupSignedOut] when BackupSignOut is added',
      build: () {
        when(mockBackupAuthBridge.signOut()).thenAnswer((_) async => Future.value());
        return backupBloc;
      },
      act: (bloc) => bloc.add(BackupSignOut()),
      expect: () => [
        BackupSignedOut(),
      ],
      verify: (_) {
        verify(mockBackupAuthBridge.signOut()).called(1);
      },
    );
  });
}
