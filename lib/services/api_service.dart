import 'dart:html' as html;
import 'dart:convert';
import 'package:explorasyon_peyi/models/models.dart';

class ApiService {
  // Baz URL pou API peyi yo
  static const String urlBaz = 'https://restcountries.com/v3.1';

  // Jwenn tout peyi yo
  static Future<List<Peyi>> jwennToutPeyi() async {
    try {
      html.HttpRequest request = await html.HttpRequest.request(
        '$urlBaz/all?fields=name,capital,region,flags,population',
        method: 'GET',
      );

      if (request.status == 200) {
        List<dynamic> data = jsonDecode(request.responseText!);
        return data.map((json) => Peyi.fromJson(json)).toList();
      } else {
        throw "Erè API: ${request.status}";
      }
    } catch (e) {
      throw "Pa ka chaje peyi yo. Tcheke koneksyon w.";
    }
  }

  // Jwenn yon peyi pa non
  static Future<Peyi?> jwennPeyiPaNon(String name) async {
    try {
      html.HttpRequest request = await html.HttpRequest.request(
        '$urlBaz/name/$name?fields=name,capital,region,flags,population',
        method: 'GET',
      );

      if (request.status == 200) {
        List<dynamic> data = jsonDecode(request.responseText!);
        if (data.isNotEmpty) {
          return Peyi.fromJson(data[0]);
        }
      }
      return null;
    } catch (e) {
      print('Erè: $e');
      return null;
    }
  }
}
