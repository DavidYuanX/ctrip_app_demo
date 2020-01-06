import 'dart:async';
import 'dart:convert';
import 'package:ctrip_app_demo/model/home_model.dart';
import 'package:http/http.dart' as http;

const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

class HomeDao {
  static Future<TravelModel> fetch() async {
    final response = await http.get(HOME_URL);

    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); // 修复 中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelModel.fromJson(result);
    } else {
      throw Exception('Failed to load home_page.json');
    }
  }
}
