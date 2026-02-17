import 'package:shared_preferences/shared_preferences.dart';

class FavoriteService {
  // Kle kote n sere lis favori yo
  static const String _kleFavori = 'favorites';

  // Ajoute oswa retire yon peyi nan lis favori
  Future<void> chanjeFavori(String nonPeyi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lisFavori = prefs.getStringList(_kleFavori) ?? [];

      if (lisFavori.contains(nonPeyi)) {
        lisFavori.remove(nonPeyi);
      } else {
        lisFavori.add(nonPeyi);
      }

      await prefs.setStringList(_kleFavori, lisFavori);
    } catch (e) {
      print('Erè pandan jere favori: $e');
    }
  }

  // Verifye si yon peyi deja nan favori
  Future<bool> seFavori(String nonPeyi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lisFavori = prefs.getStringList(_kleFavori) ?? [];
      return lisFavori.contains(nonPeyi);
    } catch (e) {
      return false;
    }
  }

  // Jwenn tout non peyi ki nan favori
  Future<List<String>> jwennFavori() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(_kleFavori) ?? [];
    } catch (e) {
      return [];
    }
  }

  // Retire yon peyi nan favori
  Future<void> retireFavori(String nonPeyi) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lisFavori = prefs.getStringList(_kleFavori) ?? [];
      lisFavori.remove(nonPeyi);
      await prefs.setStringList(_kleFavori, lisFavori);
    } catch (e) {
      print('Erè pandan efase favori: $e');
    }
  }

  // Efase tout favori yo
  Future<void> efaseToutFavori() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_kleFavori);
    } catch (e) {
      print('Erè pandan efase tout favori: $e');
    }
  }
}
