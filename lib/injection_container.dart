import 'package:card_hive/features/backup/data/bridge/backup_auth_bridge.dart';
import 'package:card_hive/features/backup/data/datasource/drive_remote_service.dart';
import 'package:card_hive/features/backup/data/repository/backup_auth_bridge_impl.dart';
import 'package:card_hive/features/backup/data/repository/backup_repository_impl.dart';
import 'package:card_hive/features/backup/domain/repositories/backup_repository.dart';
import 'package:card_hive/features/backup/domain/repositories/drive_remote_repository.dart';
import 'package:card_hive/features/backup/domain/usecases/backup_usecase.dart';
import 'package:card_hive/features/backup/domain/usecases/restore_usecase.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:card_hive/features/cards/data/datasources/assets_store_service.dart';
import 'package:card_hive/features/cards/data/datasources/cards_service.dart';
import 'package:card_hive/features/cards/data/models/card_model.dart';
import 'package:card_hive/features/cards/data/repository/card_repository_impl.dart';
import 'package:card_hive/features/cards/data/repository/store_repository_impl.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';
import 'package:card_hive/features/cards/domain/repository/store_repositry.dart';
import 'package:card_hive/features/cards/domain/usecases/add_or_update_card_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/get_all_cards_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/import_store_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/remove_card_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/search_stores_usecase.dart';
import 'package:card_hive/features/cards/domain/usecases/watch_all_cards_usecase.dart';
import 'package:card_hive/objectbox.g.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  getIt.registerSingleton(Logger());
  await _initServices();
  _initRepositories();
  _initUseCases();

  await _initBackUpFeature();
}

Future<void> _initBackUpFeature() async {
  getIt.registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new);

  final googleAuth = BackupAuthBridgeImpl(getIt());
  await googleAuth.initialize(
    serverClientId: dotenv.env['GOOGLE_SERVER_CLIENT_ID'],
  );
  getIt
    ..registerSingleton<BackupAuthBridge>(googleAuth)
    ..registerSingleton<DriveRemoteRepository>(DriveRemoteService())
    //..registerLazySingleton<BackupRepository>(DriveBackupRepository(getIt(), getIt()))
    ..registerLazySingleton<BackupRepository>(
      () => BackupRepositoryImpl(getIt(), getIt()),
    )
    ..registerLazySingleton<BackupUseCase>(() => BackupUseCase(getIt()))
    ..registerLazySingleton<RestoreUseCase>(() => RestoreUseCase(getIt()))
    ..registerFactory(
      () => BackupBloc(
        authBridge: getIt(),
        backupUseCase: getIt(),
        restoreUseCase: getIt(),
      ),
    );
}

Future<void> _initServices() async {
  final store = await openStore();
  final box = store.box<CardModel>();
  getIt
    ..registerSingleton<Store>(store)
    ..registerSingleton<Box<CardModel>>(box)
    ..registerSingleton<CardsService>(CardsService(box))
    ..registerSingleton<AssetsStoreService>(AssetsStoreService());
}

void _initRepositories() {
  getIt
    ..registerSingleton<CardRepository>(CardRepositoryImpl(getIt(), getIt()))
    ..registerSingleton<StoreRepositry>(StoreRepositoryImpl(getIt()));
}

void _initUseCases() {
  getIt
    ..registerSingleton<AddOrUpdateCardUsecase>(AddOrUpdateCardUsecase(getIt()))
    ..registerSingleton<RemoveCardUsecase>(RemoveCardUsecase(getIt()))
    ..registerSingleton<GetAllCardsUsecase>(GetAllCardsUsecase(getIt()))
    ..registerSingleton<WatchAllCardsUsecase>(WatchAllCardsUsecase(getIt()))
    ..registerSingleton<ImportStoreUsecase>(ImportStoreUsecase(getIt()))
    ..registerSingleton<SearchStoresUsecase>(SearchStoresUsecase(getIt()));
}
