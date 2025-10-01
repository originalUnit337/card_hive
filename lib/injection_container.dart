import 'package:card_hive/features/cards/data/datasources/cards_service.dart';
import 'package:card_hive/features/cards/data/models/card_model.dart';
import 'package:card_hive/features/cards/data/repository/card_repository_impl.dart';
import 'package:card_hive/features/cards/domain/repository/card_repository.dart';
import 'package:card_hive/features/cards/domain/usecases/add_or_update_card_usecase.dart';
import 'package:card_hive/objectbox.g.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  getIt.registerSingleton(Logger());
  await _initServices();
  _initRepositories();
  _initUseCases();
}

Future<void> _initServices() async {
  final store = await openStore();
  final box = store.box<CardModel>();
  getIt
    ..registerSingleton<Store>(store)
    ..registerSingleton<Box<CardModel>>(box)
    ..registerSingleton<CardsService>(CardsService(box));
}

void _initRepositories() {
  getIt.registerSingleton<CardRepository>(CardRepositoryImpl(getIt(), getIt()));
}

void _initUseCases() {
  getIt.registerSingleton<AddOrUpdateCardUsecase>(
    AddOrUpdateCardUsecase(getIt()),
  );
}
