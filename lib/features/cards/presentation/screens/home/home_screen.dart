import 'dart:io';
import 'dart:ui';

import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_bloc.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_event.dart';
import 'package:card_hive/features/backup/presentation/bloc/backup_state.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_state.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

void _showBackupDialog(BuildContext context, List<CardEntity> cards) {
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: const Text('Backup'),
          content: Column(
            children: [
              const Text(r'Last time backup: ${placeholder}}'),
              ListTile(
                title: const Text('Backup'),
                onTap: () {
                  context.read<BackupBloc>().add(BackupTry(cards));
                },
              ),
              ListTile(
                title: const Text('Restore'),
                onTap: () {
                  context.read<BackupBloc>().add(BackupRestore());
                },
              ),
            ],
          ),
        ),
  );
}

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
          // backup button
          BlocConsumer<BackupBloc, BackupState>(
            listener: (context, state) {
              if (state is BackupSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Backup successful')),
                );
              } else if (state is BackupFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Backup failed: ${state.exception}')),
                );
              } else if (state is BackupNeedInteractiveSignIn) {
                // interactive sign-in must be started from user gesture -> show dialog/perform interactive sign-in immediately
                // we dispatch InteractiveSignIn which calls authBridge.authenticate() in data layer (it must be called in gesture context)
                context.read<BackupBloc>().add(
                  BackupInteractiveSignIn(cards: state.cards),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is BackupLoading;
              return BlocBuilder<HomeBloc, HomeState>(
                builder:
                    (context, state) =>
                        state is HomeLoaded
                            ? IconButton(
                              onPressed:
                                  isLoading
                                      ? null
                                      : () {
                                        // onPressed is a user gesture -> safe to call authenticate inside bloc via authBridge
                                        // context.read<BackupBloc>().add(BackupTry());
                                        _showBackupDialog(context, state.cards);
                                      },
                              icon:
                                  isLoading
                                      ? const SizedBox(
                                        width: 24,
                                        height: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                      : DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: appPalette.primary,
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                        ),
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                            left: 4,
                                            right: 4,
                                          ),
                                          child: Icon(
                                            Icons.cloud_upload,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                            )
                            : const CircularProgressIndicator(),
              );
            },
          ),
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
        Logger().d('barcode svg: ${items[index].rawBarcodeSvg}');
        final item = items[index];
        //! null - no logo
        //! true - custom logo
        //! false - premade logo
        final customLogo = item.logoPath?.contains('logo_');
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
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (item.logoPath != null && item.logoPath!.isNotEmpty)
                      Image.asset(
                        'assets/logos/${item.logoPath}',
                        errorBuilder: (context, error, stackTrace) {
                          return Image.file(
                            File(item.logoPath!),
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    else
                      Container(color: item.color),
                    if (customLogo ?? false)
                      ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                          child: Container(),
                        ),
                      ),
                    if (customLogo == null || customLogo)
                      Center(
                        child:
                            item.logoPath != null && item.logoPath!.isNotEmpty
                                ? Image.asset(
                                  'assets/logos/${item.logoPath}',
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.file(File(item.logoPath!));
                                  },
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.contain,
                                )
                                : Text(
                                  item.name,
                                  style: const TextStyle(color: Colors.white),
                                ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
