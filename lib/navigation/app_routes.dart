enum AppRoutes {
  homeRoute(path: '/', name: 'home'),

  cardInfo(path: '/card_info', name: 'cardInfo'),
  cardInfoNotes(path: '/card_info/notes', name: 'cardInfoNotes'),
  cardInfoPictures(path: '/card_info/pictures', name: 'cardInfoPictures'),
  cardInfoEdit(path: '/card_info/edit', name: 'cardInfoEdit'),

  storeList(path: '/store_list', name: 'storeList'),
  scannerScreen(path: '/store_list/scanner_screen', name: 'scanner_screen'),
  addPremadeCard(
    path: '/store_list/scanner_screen/add_premade_card',
    name: 'addPremadeCard',
  );

  final String path;
  final String name;
  const AppRoutes({required this.path, required this.name});
}
