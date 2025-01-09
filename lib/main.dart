import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApiExample(),
    );
  }
}

class ApiExample extends StatefulWidget {
  @override
  _ApiExampleState createState() => _ApiExampleState();
}

class _ApiExampleState extends State<ApiExample> {
  // Data API
  Future<Map<String, dynamic>>? apiData;

  @override
  void initState() {
    super.initState();
    apiData = fetchData(); // Memanggil fetchData() untuk mengambil data API
  }

  // Fungsi untuk mengambil data dari API
  Future<Map<String, dynamic>> fetchData() async {
    try {
      // Ganti URL berikut dengan endpoint API yang sesuai
      final response =
          await http.get(Uri.parse('https://api.example.com/data'));

      if (response.statusCode == 200) {
        // Jika server memberikan response dengan status code 200, parsing data JSON
        return json.decode(response.body);
      } else {
        // Jika terjadi error
        throw Exception('Gagal memuat data');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contoh API'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Kesalahan: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            // Menampilkan data dari API
            final data = snapshot.data!;
            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text('Nama Artist: ${data['name'] ?? 'Tidak Diketahui'}'),
                Text('Judul Rilis: ${data['title'] ?? 'Tidak Diketahui'}'),
              ],
            );
          } else {
            return Center(child: Text('Data tidak tersedia'));
          }
        },
      ),
    );
  }
}
