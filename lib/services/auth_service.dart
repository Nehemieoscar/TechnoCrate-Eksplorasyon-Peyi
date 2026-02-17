import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:explorasyon_peyi/models/user.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  // Kle pou lis itilizatè yo nan SharedPreferences
  static const String _lisItilizateKey = 'users_list';
  // Kle pou itilizatè kouran an
  static const String _itilKouranKey = 'current_user';

  /// Enskri yon nouvo itilizatè
  Future<bool> enskri(String nonItilizate, String imel, String modpas) async {
    try {
      // Validasyon senp
      if (nonItilizate.isEmpty || imel.isEmpty || modpas.isEmpty) {
        throw 'Tout chan yo obligatwa';
      }

      if (nonItilizate.length < 3) {
        throw 'Non itilizatè a dwe gen omwen 3 karaktè';
      }

      if (!imel.contains('@')) {
        throw 'Imel pa valab';
      }

      if (modpas.length < 6) {
        throw 'Modpas la dwe gen omwen 6 karaktè';
      }

      final prefs = await SharedPreferences.getInstance();

      // Tcheke si gen itilizatè deja
      final usersJson = prefs.getStringList(_lisItilizateKey) ?? [];
      for (var itilStr in usersJson) {
        final itil = User.fromJson(jsonDecode(itilStr));
        if (itil.imel == imel) {
          throw 'Imel sa a deja itilize';
        }
        if (itil.nonItilizate == nonItilizate) {
          throw 'Non itilizatè sa a deja itilize';
        }
      }

      // Kreye nouvo itilizatè (pa bliye: pa sove modpas an klè nan pwodiksyon)
      final nouvoItil = User(
        id: const Uuid().v4(),
        nonItilizate: nonItilizate,
        imel: imel,
        modpas: modpas,
        kreyeLe: DateTime.now(),
      );

      usersJson.add(jsonEncode(nouvoItil.toJson()));
      await prefs.setStringList(_lisItilizateKey, usersJson);
      return true;
    } catch (e) {
      rethrow;
    }
  }

  /// Konekte yon itilizatè
  Future<bool> konekte(String imel, String modpas) async {
    try {
      if (imel.isEmpty || modpas.isEmpty) {
        throw 'Imel ak modpas obligatwa';
      }

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_lisItilizateKey) ?? [];

      for (var itilStr in usersJson) {
        final itil = User.fromJson(jsonDecode(itilStr));
        if (itil.imel == imel && itil.modpas == modpas) {
          // Jwenn itilizatè a
          await prefs.setString(_itilKouranKey, jsonEncode(itil.toJson()));
          return true;
        }
      }

      throw 'Imel oswa modpas enkòrèk';
    } catch (e) {
      rethrow;
    }
  }

  /// Jwenn itilizatè aktif la
  Future<User?> jwennItilizateAktif() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final itilJson = prefs.getString(_itilKouranKey);

      if (itilJson != null) {
        return User.fromJson(jsonDecode(itilJson));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Tcheke si gen yon itilizatè ki konekte
  Future<bool> seKonekte() async {
    final itil = await jwennItilizateAktif();
    return itil != null;
  }

  /// Dekonekte itilizatè a
  Future<void> dekonekte() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_itilKouranKey);
  }
}
