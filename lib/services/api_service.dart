import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = "https://restapi.santosdev.site";

  /// =============================
  /// LOGIN DO USUÁRIO
  /// =============================
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final url = Uri.parse("$baseUrl/user/login");

    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Erro no login: ${response.body}");
    }
  }

  /// =============================
  /// ENVIO DE PROBLEMA COM IMAGENS
  /// =============================
  static Future<void> sendProblemReport({
    required String description,
    required int categoryId,
    required int locationId,
    required List<File> images,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString("user");

      if (userString == null) {
        throw Exception("Usuário não encontrado. Faça login novamente.");
      }

      final user = jsonDecode(userString);
      final studentId = user['id'];

      final Map<String, dynamic> dto = {
        "description": description,
        "category_id": categoryId,
        "local_id": locationId,
        "student_id": studentId,
      };

      final uri = Uri.parse("$baseUrl/problemas");
      final request = http.MultipartRequest("POST", uri);

      request.fields["dto"] = jsonEncode(dto);

      for (File image in images) {
        request.files.add(
          await http.MultipartFile.fromPath("photos", image.path),
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Erro ao enviar reporte: $responseBody");
      }

      print("Reporte enviado com sucesso: $responseBody");
    } catch (e) {
      throw Exception("Erro ao enviar o reporte: $e");
    }
  }

  /// =============================
  /// BUSCAR REPORTES DO USUÁRIO
  /// =============================
  static Future<List<dynamic>> fetchUserReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString("user");

      if (userString == null) {
        print("Usuário não encontrado no SharedPreferences.");
        throw Exception("Usuário não logado.");
      }

      final user = jsonDecode(userString);
      final studentId = user['id'];

      final url = Uri.parse("$baseUrl/problemas/user/$studentId");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json is List) {
          return json;
        } else if (json is Map && json["data"] is List) {
          return json["data"];
        }
        return [];
      } else {
        throw Exception("Erro ao buscar reports: ${response.body}");
      }
    } catch (e) {
      print("Erro no fetchUserReports: $e");
      return [];
    }
  }

  /// =============================
  /// BUSCAR DETALHES DO PROBLEMA
  /// =============================
  static Future<Map<String, dynamic>> fetchProblemDetail(int problemId) async {
    final url = Uri.parse("$baseUrl/problemas/$problemId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body is Map<String, dynamic>) {
        if (body.containsKey("data") && body["data"] is Map) {
          return Map<String, dynamic>.from(body["data"]);
        }
        return Map<String, dynamic>.from(body);
      } else {
        throw Exception("Formato inesperado na resposta do problema.");
      }
    } else {
      throw Exception("Erro ao buscar detalhe do problema: ${response.body}");
    }
  }

  /// =============================
  /// BUSCAR FOTOS DO PROBLEMA (AJUSTADO)
  /// =============================
  static Future<List<String>> fetchProblemPhotos(int problemId) async {
    final url = Uri.parse("$baseUrl/problemas/photos/$problemId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // ✅ Caso da sua API: {"problemId": 20010, "photosUrl": [ ... ]}
      if (body is Map && body["photosUrl"] is List) {
        return (body["photosUrl"] as List).map((e) => e.toString()).toList();
      }

      // ✅ Mantém compatibilidade com outros formatos
      if (body is List) {
        return body.map((e) => e.toString()).toList();
      } else if (body is Map && body["data"] is List) {
        return (body["data"] as List).map((e) => e.toString()).toList();
      } else if (body is Map && body.containsKey("photos")) {
        return (body["photos"] as List).map((e) => e.toString()).toList();
      }

      return [];
    } else {
      throw Exception("Erro ao buscar fotos do problema: ${response.body}");
    }
  }

  /// =============================
  /// BUSCAR MENSAGENS DO PROBLEMA
  /// =============================
  static Future<List<Map<String, dynamic>>> fetchProblemMessages(int problemId) async {
    final url = Uri.parse("$baseUrl/messages/problem/$problemId");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      List<dynamic> list;
      if (body is List) {
        list = body;
      } else if (body is Map && body["data"] is List) {
        list = body["data"];
      } else {
        return [];
      }

      return list.map<Map<String, dynamic>>((e) {
        if (e is Map<String, dynamic>) return Map<String, dynamic>.from(e);
        if (e is Map) return Map<String, dynamic>.from(e.cast<String, dynamic>());
        return {"message": e.toString()};
      }).toList();
    } else {
      throw Exception("Erro ao buscar mensagens do problema: ${response.body}");
    }
  }
}
