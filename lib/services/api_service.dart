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
      // Recupera o usuário logado do SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userString = prefs.getString("user");

      if (userString == null) {
        throw Exception("Usuário não encontrado. Faça login novamente.");
      }

      final user = jsonDecode(userString);
      final studentId = user['id'];

      // Monta o DTO em JSON
      final Map<String, dynamic> dto = {
        "description": description,
        "category_id": categoryId,
        "local_id": locationId,
        "student_id": studentId,
      };

      final uri = Uri.parse("$baseUrl/problemas");
      final request = http.MultipartRequest("POST", uri);

      // Campo "dto" como string JSON
      request.fields["dto"] = jsonEncode(dto);

      // Adiciona cada imagem à requisição
      for (File image in images) {
        request.files.add(
          await http.MultipartFile.fromPath("photos", image.path),
        );
      }

      // Envia a requisição
      final response = await request.send();

      // Converte o corpo da resposta para string
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Erro ao enviar reporte: $responseBody");
      }

      // Caso sucesso, você pode fazer algo com o responseBody se necessário
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

      final url = Uri.parse(
        "https://restapi.santosdev.site/problemas/user/$studentId",
      );
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
}
