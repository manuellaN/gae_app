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

  /// =============================
/// BUSCAR DETALHES, FOTOS E MENSAGENS DO PROBLEMA
/// =============================
static Future<Map<String, dynamic>> fetchProblemDetail(int problemId) async {
  final url = Uri.parse("$baseUrl/problemas/$problemId");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    // API pode retornar lista ou objeto com campo "data"
    if (body is Map<String, dynamic>) {
      // se houver "data" e for Map, retorna body["data"]
      if (body.containsKey("data") && body["data"] is Map) {
        return Map<String, dynamic>.from(body["data"]);
      }
      return Map<String, dynamic>.from(body);
    } else {
      throw Exception("Formato inesperado na resposta de detalhe do problema.");
    }
  } else {
    throw Exception("Erro ao buscar detalhe do problema: ${response.body}");
  }
}

static Future<List<String>> fetchProblemPhotos(int problemId) async {
  final url = Uri.parse("$baseUrl/problemas/photos/$problemId");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    // Se a API retornar um array de strings ou um objeto com data
    if (body is List) {
      return body.map((e) => e.toString()).toList();
    } else if (body is Map && body["data"] is List) {
      return (body["data"] as List).map((e) => e.toString()).toList();
    } else if (body is Map && body.containsKey("photos") && body["photos"] is List) {
      return (body["photos"] as List).map((e) => e.toString()).toList();
    } else {
      return [];
    }
  } else {
    throw Exception("Erro ao buscar fotos do problema: ${response.body}");
  }
}

static Future<List<String>> fetchProblemMessages(int problemId) async {
  final url = Uri.parse("$baseUrl/messages/problem/$problemId");
  final response = await http.get(url);
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    if (body is List) {
      return body.map((e) {
        // tenta extrair campo 'message' ou 'text' se o objeto for Map
        if (e is Map) {
          if (e.containsKey("message")) return e["message"].toString();
          if (e.containsKey("text")) return e["text"].toString();
          // fallback: converte map em JSON string curta
          return jsonEncode(e);
        }
        return e.toString();
      }).toList();
    } else if (body is Map && body["data"] is List) {
      return (body["data"] as List).map((e) {
        if (e is Map) {
          return e["message"]?.toString() ?? e["text"]?.toString() ?? jsonEncode(e);
        }
        return e.toString();
      }).toList();
    } else {
      return [];
    }
  } else {
    throw Exception("Erro ao buscar mensagens do problema: ${response.body}");
  }
}

}
