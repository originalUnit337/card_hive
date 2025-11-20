import 'dart:io';

import 'package:card_hive/core/ui_kit/palette/app_palette.dart';
import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_state.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CardInfoPremadeEditScreen extends StatefulWidget {
  final CardEntity card;
  const CardInfoPremadeEditScreen({required this.card, super.key});

  @override
  State<CardInfoPremadeEditScreen> createState() =>
      _CardInfoPremadeEditScreenState();
}

class _CardInfoPremadeEditScreenState extends State<CardInfoPremadeEditScreen> {
  late final TextEditingController _numberController;
  late final TextEditingController _labelController;

  @override
  void initState() {
    super.initState();
    _numberController = TextEditingController(text: widget.card.number);
    _labelController = TextEditingController(text: widget.card.label ?? '');
  }

  void _saveCard() {
    context.read<CardInfoBloc>().add(
      SaveCardEvent(
        widget.card.copyWith(
          number: _numberController.text,
          label: _labelController.text,
        ),
      ),
    );
    final cards = context.read<HomeBloc>().cards;
    final result = cards.indexWhere((el) => el.id == widget.card.id);
    // ! if UPDATE card
    if (result != -1) {
      cards[result] = widget.card.copyWith(
        number: _numberController.text,
        label: _labelController.text,
      );
      context.read<HomeBloc>().add(UpdateCardsEvent(cards));
    }
    // ! if ADD new card
  }

  @override
  Widget build(BuildContext context) {
    final currentPalette = AppPalette.of(context);
    // ! must be always false
    final customLogo = widget.card.logoPath?.contains('logo_');
    return BlocListener<CardInfoBloc, CardInfoState>(
      listener: (context, state) {
        if (state is CardInfoLoaded) {
          final addedCardOrEditedCard = context.read<CardInfoBloc>().card;
          final cards = context.read<HomeBloc>().cards;
          final result = cards.indexWhere(
            (el) => el.id == addedCardOrEditedCard?.id,
          );
          if (addedCardOrEditedCard != null && result == -1) {
            cards.add(addedCardOrEditedCard);
          }
          context.read<HomeBloc>().add(UpdateCardsEvent(cards));
          context.pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 100,
          leading: TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),
          ),
          actions: [
            TextButton(onPressed: _saveCard, child: const Text('Save')),
          ],
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(15),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Form(
                    child: ColoredBox(
                      color: currentPalette.appBarbackground,
                      child: Column(
                        spacing: 12,
                        children: [
                          if (customLogo ?? false)
                            Image.file(File(widget.card.logoPath!))
                          else
                            Image.asset('assets/logos/${widget.card.logoPath}'),
                          const Text('Card Number'),
                          TextFormField(controller: _numberController),
                          const Text('Label'),
                          TextFormField(controller: _labelController),
                          TextButton(
                            onPressed: _saveCard,
                            child: const Text('Save'),
                          ),
                          TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Are you sure you want to delete this card ?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        child: const Text('CANCEL'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<CardInfoBloc>().add(
                                            RemoveCardEvent(widget.card.id),
                                          );
                                          final cards =
                                              context.read<HomeBloc>().cards
                                                ..removeWhere(
                                                  (item) =>
                                                      item.id == widget.card.id,
                                                );
                                          context.read<HomeBloc>().add(
                                            UpdateCardsEvent(cards),
                                          );
                                          context
                                            ..pop()
                                            ..pop()
                                            ..pop();
                                        },
                                        child: const Text('DELETE CARD'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.delete),
                                Text('Delete Card'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
