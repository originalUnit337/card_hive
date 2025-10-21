import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_state.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appPalette = AppPalette.of(context);
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: appPalette.appBarbackground,
        title: const Text('Cards'),
        actions: [
          IconButton(
            onPressed: () => context.push(AppRoutes.storeList.path),
            icon: DecoratedBox(
              decoration: BoxDecoration(
                color: appPalette.primary,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(color: appPalette.background),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              return switch (state) {
                HomeInitial() => const CircularProgressIndicator(),
                HomeLoading() => const CircularProgressIndicator(),
                HomeLoaded() => _BuildGridView(items: state.cards),
                HomeError() => Center(child: Text(state.message)),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _BuildGridView extends StatelessWidget {
  const _BuildGridView({required this.items});

  final List<CardEntity> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.6,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(20),

          child: Material(
            child: InkWell(
              onTap: () {
                //FocusScope.of(context).unfocus();
                // Future.delayed(Duration(milliseconds: 100)).then(
                //   (_) =>
                //       context.mounted
                //           ? context.push(AppRoutes.cardInfo.path)
                //           : null,
                // );
                context.read<CardInfoBloc>().add(const ResetCardEvent());
                context.push(AppRoutes.cardInfo.path, extra: item);
              },
              splashColor: Colors.black54,
              highlightColor: Colors.black54,
              splashFactory: InkRipple.splashFactory,
              child: Ink(
                decoration: BoxDecoration(color: item.color),
                child: Center(child: Text(item.name)),
              ),
            ),
          ),
        );
      },
    );
  }
}
