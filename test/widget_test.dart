import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Mocking the HTTP request
class MockHttpClient extends http.Client {
  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) async {
    // Mengembalikan response palsu dengan data JSON
    return http.Response(
      jsonEncode({'name': 'Artist Name', 'title': 'Album Title'}),
      200,
    );
  }

  @override
  void close() {
    // Implementasi close jika perlu
  }

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    throw UnimplementedError();
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) {
    throw UnimplementedError();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    throw UnimplementedError();
  }
}

class MyApp extends StatelessWidget {
  final http.Client httpClient;

  const MyApp({Key? key, required this.httpClient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ApiExample(httpClient: httpClient),
    );
  }
}

class ApiExample extends StatefulWidget {
  final http.Client httpClient;

  const ApiExample({Key? key, required this.httpClient}) : super(key: key);

  @override
  _ApiExampleState createState() => _ApiExampleState();
}

class _ApiExampleState extends State<ApiExample> {
  Future<Map<String, dynamic>>? apiData;

  @override
  void initState() {
    super.initState();
    apiData = fetchData();
  }

  Future<Map<String, dynamic>> fetchData() async {
    final response =
        await widget.httpClient.get(Uri.parse('https://api.example.com/data'));
    return jsonDecode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contoh API'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: apiData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Kesalahan: ${snapshot.error}'));
          } else if (snapshot.hasData) {
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

void main() {
  testWidgets('Test API data fetch and display', (WidgetTester tester) async {
    // Ganti dengan httpClient palsu
    final httpClient = MockHttpClient();

    // Bangun aplikasi dan render frame
    await tester.pumpWidget(MyApp(httpClient: httpClient));

    // Verifikasi loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Tunggu hingga Future selesai dan trigger frame
    await tester.pumpAndSettle();

    // Verifikasi data dari API yang sudah di-mock
    expect(find.text('Nama Artist: Artist Name'), findsOneWidget);
    expect(find.text('Judul Rilis: Album Title'), findsOneWidget);
  });
}
