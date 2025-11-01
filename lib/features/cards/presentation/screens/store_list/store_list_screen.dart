import 'package:card_hive/features/cards/presentation/screens/store_list/bloc/store_list_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/bloc/store_list_event.dart';
import 'package:card_hive/features/cards/presentation/screens/store_list/bloc/store_list_state.dart';
import 'package:card_hive/injection_container.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StoreListScreen extends StatelessWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StoreListBloc(getIt(), getIt(), getIt()),
      child: BlocBuilder<StoreListBloc, StoreListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Store List')),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    onChanged: (value) {
                      if (value.length >= 2) {
                        context.read<StoreListBloc>().add(
                          SearchStoresEvent(value),
                        );
                      }
                      if (value.length == 1) {
                        context.read<StoreListBloc>().add(
                          const ClearSearchEvent(),
                        );
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(width: 0.5),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<StoreListBloc, StoreListState>(
                    builder: (context, state) {
                      return switch (state) {
                        StoreListInitial() => Column(
                          children: [
                            const Text(
                              'Most popular cards',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Material(
                              child: InkWell(
                                onTap: () {
                                  context.push(AppRoutes.scannerScreen.path);
                                },
                                child: Ink(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  height: 50,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 60,
                                        height: 40,
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.amber,
                                        ),
                                      ),
                                      Text('Add custom card'),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Text('All cards'),
                          ],
                        ),
                        StoreListLoading() => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        StoreListLoaded() => Expanded(
                          child: ListView.builder(
                            itemCount: state.stores.length,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      context.push(
                                        AppRoutes.scannerScreen.path,
                                        extra: state.stores[index],
                                      );
                                    },
                                    leading: ClipRRect(
                                      borderRadius:
                                          BorderRadiusGeometry.circular(10),
                                      child: Container(
                                        color: state.stores[index].colorValue,
                                        width: 100,
                                        height: 60,
                                        child: AspectRatio(
                                          aspectRatio:
                                              state
                                                  .stores[index]
                                                  .logoAspectRatio ??
                                              2 / 3,
                                          child: Image.asset(
                                            'assets/logos/${state.stores[index].logoReference}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    title: Text(state.stores[index].name),
                                    subtitle: Text(state.stores[index].region),
                                  ),
                                ),
                          ),
                        ),
                        StoreListError() => Center(child: Text(state.message)),
                      };
                    },
                  ),
                  // const Text(
                  //   'Most popular cards',
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  // ),
                  // Material(
                  //   child: InkWell(
                  //     onTap: () => context.push(AppRoutes.addCustomCard.path),
                  //     child: Ink(
                  //       decoration: const BoxDecoration(color: Colors.white),
                  //       height: 50,
                  //       child: const Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           SizedBox(
                  //             width: 60,
                  //             height: 40,
                  //             child: Icon(Icons.add, color: Colors.amber),
                  //           ),
                  //           Text('Add custom card'),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // const Text('All cards'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
