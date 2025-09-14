enum AppRoutes {
  homeRoute(path: '/', name: 'home'),
  cardInfo(path: '/card_info', name: 'cardInfo'),
  cardInfoNotes(path: '/card_info/notes', name: 'cardInfoNotes'),
  cardInfoPictures(path: '/card_info/pictures', name: 'cardInfoPictures');

  final String path;
  final String name;
  const AppRoutes({required this.path, required this.name});
}
