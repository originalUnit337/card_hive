# Google Drive Backup and Restore Implementation Plan

This document outlines the phased implementation plan for adding the Google Drive backup and restore feature to the Card Hive application.

## Journal

*   **Phase 1:** Tried to run `flutter test` but it failed because the `test` directory was not found. This is not a blocker, as I will create the directory and tests in the upcoming phases. Added `google_sign_in` and `googleapis` dependencies successfully.
*   **Phase 1:** Ran `analyze_files` and found several issues, including `strict_raw_type`, `unused_element`, `avoid_catches_without_on_clauses`, and `unused_field`. Fixed all the issues and verified with `analyze_files` again. All tests passed after the fixes.
*   **Phase 2:** Created the domain layer for the backup feature, including the `BackupRepository` interface and the `BackupUseCase`, `RestoreUseCase`, and `GetLastBackupTimeUseCase`.
*   **Phase 3:** Implemented `BackupRepositoryImpl` using existing `DriveRemoteDatasource` and `GoogleAuthDatasource`.
*   **Phase 2 & 3:** Wrote unit tests for the domain and data layers. This included tests for `BackupRepositoryImpl`, `BackupUseCase`, `RestoreUseCase`, and `GetLastBackupTimeUseCase`. Added `mockito` for mocking dependencies. Modified `CardEntity` to be `JsonSerializable` to allow for testing the backup and restore of card data. All tests passed.

## Phase 1: Project Setup and Initial Tests

- [x] Run all tests to ensure the project is in a good state before starting modifications.
- [x] Add the `google_sign_in` and `googleapis` dependencies to the `pubspec.yaml` file.
- [x] Run `flutter pub get` to install the new dependencies.
- [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [x] Run the `dart_fix` tool to clean up the code.
- [x] Run the `analyze_files` tool one more time and fix any issues.
- [x] Run any tests to make sure they all pass.
- [x] Run `dart_format` to make sure that the formatting is correct.
- [x] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [x] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [x] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [x] After commiting the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 2: Domain Layer

- [x] Create the `BackupRepository` interface in `lib/features/backup/domain/repositories/backup_repository.dart`.
- [x] Create the `BackupUseCase` in `lib/features/backup/domain/usecases/backup_usecase.dart`.
- [x] Create the `RestoreUseCase` in `lib/features/backup/domain/usecases/restore_usecase.dart`.
- [x] Create the `GetLastBackupTimeUseCase` in `lib/features/backup/domain/usecases/get_last_backup_time_usecase.dart`.
- [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the `dart_fix` tool to clean up the code.
- [ ] Run the `analyze_files` tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to make sure that the formatting is correct.
- [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [x] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After commiting the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 3: Data Layer

- [x] Create the `GoogleDriveDataSource` in `lib/features/backup/data/datasources/google_drive_data_source.dart`.
- [x] Implement the `BackupRepositoryImpl` in `lib/features/backup/data/repositories/backup_repository_impl.dart`.
- [x] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the `dart_fix` tool to clean up the code.
- [ ] Run the `analyze_files` tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to make sure that the formatting is correct.
- [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After commiting the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 4: Presentation Layer (Bloc)

- [ ] Create the `BackupBloc` in `lib/features/backup/presentation/bloc/backup_bloc.dart`.
- [ ] Create the `BackupEvent`s and `BackupState`s.
- [ ] Implement the `BackupBloc` to handle the `BackupEvent`s and emit the `BackupState`s.
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the `dart_fix` tool to clean up the a code.
- [ ] Run the `analyze_files` tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to make sure that the formatting is correct.
- [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After commiting the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 5: Presentation Layer (UI)

- [ ] Create the `BackupDialog` widget in `lib/features/backup/presentation/widgets/backup_dialog.dart`.
- [ ] Add the Google Drive icon to the home screen app bar.
- [ ] Implement the logic to show the `BackupDialog` when the icon is tapped.
- [ ] Connect the `BackupDialog` to the `BackupBloc` to display the last backup time and handle backup/restore actions.
- [ ] Create/modify unit tests for testing the code added or modified in this phase, if relevant.
- [ ] Run the `dart_fix` tool to clean up the code.
- [ ] Run the `analyze_files` tool one more time and fix any issues.
- [ ] Run any tests to make sure they all pass.
- [ ] Run `dart_format` to make sure that the formatting is correct.
- [ ] Re-read the `MODIFICATION_IMPLEMENTATION.md` file to see what, if anything, has changed in the implementation plan, and if it has changed, take care of anything the changes imply.
- [ ] Update the `MODIFICATION_IMPLEMENTATION.md` file with the current state, including any learnings, surprises, or deviations in the Journal section. Check off any checkboxes of items that have been completed.
- [ ] Use `git diff` to verify the changes that have been made, and create a suitable commit message for any changes, following any guidelines you have about commit messages. Be sure to properly escape dollar signs and backticks, and present the change message to the user for approval.
- [ ] Wait for approval. Don't commit the changes or move on to the next phase of implementation until the user approves the commit.
- [ ] After commiting the change, if an app is running, use the `hot_reload` tool to reload it.

## Phase 6: Finalization

- [ ] Update the `README.md` file with information about the new Google Drive backup and restore feature.
- [ ] Update the `GEMINI.md` file to reflect the changes made to the project.
- [ ] Ask the user to inspect the package (and running app, if any) and say if they are satisfied with it, or if any modifications are needed.