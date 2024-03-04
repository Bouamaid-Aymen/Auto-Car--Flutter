import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:my_app_car/screens/car_list.dart';

class CarService {
  static Future<bool> deleteBycar(String id) async {
    final url = "http://localhost:3000/voiture/$id";
    final uri = Uri.parse(url);
    final response = await http.delete(uri);

    return response.statusCode == 200;
  }

  static Future<List?> fetchcar() async {
    const url = "http://localhost:3000/voiture/mycars";
    final uri = Uri.parse(url);
    String? token = await TokenStorage.getToken();
    final response =
        await http.get(uri, headers: {'authorization': 'Bearer $token'});
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as List;

      return json;
    } else {
      return null;
    }
  }


}
