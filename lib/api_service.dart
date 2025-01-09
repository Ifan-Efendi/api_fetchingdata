import 'dart:convert'; // Untuk mengolah data JSON
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> fetchData() async {
  const url =
      'https://shazam.p.rapidapi.com/artists/get-latest-release?id=73406786&l=en-US';
  var headers = newMethod;

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal mengambil data: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Kesalahan: $e');
  }
}

Map<String, String> get newMethod {
  return <String, String>{
    'x-rapidapi-key': 'eebcdf0512mshbff1e4c096d445cp1e30bfjsn780932a09b7b',
    'x-rapidapi-host': 'shazam.p.rapidapi.com',
  };
}
