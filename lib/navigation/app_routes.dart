enum AppRoutes {
  homeRoute(path: '/', name: 'home'),

  cardInfo(path: '/card_info', name: 'cardInfo'),
  cardInfoNotes(path: '/card_info/notes', name: 'cardInfoNotes'),
  cardInfoPictures(path: '/card_info/pictures', name: 'cardInfoPictures'),
  cardInfoEdit(path: '/card_info/edit', name: 'cardInfoEdit'),

  storeList(path: '/store_list', name: 'storeList'),
  addCustomCard(path: '/store_list/add_custom_card', name: 'addCustomCard');
  

  final String path;
  final String name;
  const AppRoutes({required this.path, required this.name});
}
