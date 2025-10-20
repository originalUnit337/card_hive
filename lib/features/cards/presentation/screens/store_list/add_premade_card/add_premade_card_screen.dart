import 'package:card_hive/features/cards/domain/entities/card_entity.dart';
import 'package:card_hive/features/cards/domain/entities/store_entity.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_bloc.dart';
import 'package:card_hive/features/cards/presentation/screens/card_info/bloc/card_info_event.dart';
import 'package:card_hive/navigation/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddPremadeCardScreen extends StatefulWidget {
  final StoreEntity store;
  const AddPremadeCardScreen({required this.store, super.key});

  @override
  State<AddPremadeCardScreen> createState() => _AddPremadeCardScreenState();
}

class _AddPremadeCardScreenState extends State<AddPremadeCardScreen> {
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [TextButton(onPressed: () {}, child: const Text('Save'))],
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
    context.go(AppRoutes.homeRoute.path);
    Future.microtask(
      // ignore: use_build_context_synchronously
      () => context.push(
        AppRoutes.cardInfo.path,
        extra: CardEntity(
          id: 0,
          name: 'test',
          number: 'test number',
          color: Colors.white,
        ),
      ),
    );
  }
}
