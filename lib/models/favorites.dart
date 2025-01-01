import 'package:flutter/foundation.dart';

class Favorites with ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => {..._favoriteIds};

  bool isFavorite(String id) => _favoriteIds.contains(id);

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }
}
