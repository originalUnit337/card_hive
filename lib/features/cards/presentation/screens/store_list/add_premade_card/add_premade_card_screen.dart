import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_state.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/home/bloc/home_event.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddPremadeCardScreen extends StatefulWidget {
  final StoreEntity store;
  final CardEntity? card;
  const AddPremadeCardScreen({required this.store, this.card, super.key});

  @override
  State<AddPremadeCardScreen> createState() => _AddPremadeCardScreenState();
}

class _AddPremadeCardScreenState extends State<AddPremadeCardScreen> {
  final TextEditingController _numberController = TextEditingController();

  @override
  void initState() {
    _numberController.text = widget.card?.number ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardInfoBloc, CardInfoState>(
      listener: (context, state) {
        if (state is CardInfoLoaded) {
          final addedCard = context.read<CardInfoBloc>().card;
          final cards = context.read<HomeBloc>().cards;
          if (addedCard != null) cards.add(addedCard);
          context.read<HomeBloc>().add(UpdateCardsEvent(cards));
          context.go(AppRoutes.homeRoute.path);
          Future.microtask(
            // ignore: use_build_context_synchronously
            () => context.push(AppRoutes.cardInfo.path, extra: addedCard),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            TextButton(onPressed: _saveCard, child: const Text('Save')),
          ],
        ),
        body: Padding(
          padding: const EdgeInsetsGeometry.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Column(
              spacing: 12,
              children: [
                SizedBox(
                  height: 100,
                  child: Image.asset(
                    'assets/logos/${widget.store.logoReference}',
                  ),
                ),
                const Text('Card Nubmer'),
                TextField(
                  controller: _numberController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: 'Enter your card number',
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveCard,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveCard() {
    // final numberText = _numberController.text.trim();
    // final card = CardEntity(
    //   id: 0,
    //   name: widget.store.name,
    //   number: numberText,
    //   color: widget.store.colorValue,
    //   logoPath: 'assets/logos/${widget.store.logoReference}',
    // );
    // context.read<CardInfoBloc>().add(SaveCardEvent(card));
    // context.go(
    //   AppRoutes.cardInfo.path,
    //   extra: CardEntity(
    //     id: 0,
    //     name: 'test',
    //     number: 'test number',
    //     color: Colors.white,
    //   ),
    // );
    final card = CardEntity(
      id: 0,
      name: widget.store.name,
      number: _numberController.text.trim(),
      color: widget.store.colorValue,
      logoPath: widget.store.logoReference,
      rawBarcodeSvg: widget.card?.rawBarcodeSvg,
    );
    context.read<CardInfoBloc>().add(SaveCardEvent(card));
    // final addedCard = context.read<CardInfoBloc>().card;
    // final cards = context.read<HomeBloc>().cards..add(addedCard!);
    // context.read<HomeBloc>().add(UpdateCardsEvent(cards));
    // context.go(AppRoutes.homeRoute.path);
    // Future.microtask(
    //   // ignore: use_build_context_synchronously
    //   () => context.push(AppRoutes.cardInfo.path, extra: card),
    // );
  }
}
