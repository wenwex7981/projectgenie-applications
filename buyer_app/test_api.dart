import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lib/core/models/models.dart';

void main() async {
  try {
    final res = await http.get(Uri.parse('https://projectgenie-api.onrender.com/services'));
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body);
      final data = decoded['data'] ?? decoded;
      if (data is List) {
        print('Got ${data.length} services from API');
        for (var item in data) {
          try {
            final parsed = ServiceModel.fromJson(item);
            print('Successfully parsed: ${parsed.title}');
          } catch (e, st) {
            print('ERROR Parsing Service: ${item['title']}');
            print(e);
            print(st);
            return;
          }
        }
      }
    } else {
      print('API returned ${res.statusCode}');
    }
  } catch (e) {
    print('Failed: $e');
  }
}
