import 'package:dio/dio.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';

class DataFetcher {
  final Dio dio = Dio();

  Future<List<String>> fetchProfs(String fileUrl) async {
    List<String> profs = [];
    try {
      final response = await dio.get(fileUrl, options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {
        Uint8List bytes = Uint8List.fromList(response.data);
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {
            if (row[0] != null && row[1] != null && !row[1]!.toString().toLowerCase().contains("laboratori")) {
              profs.add(row[0]!.toString());
            }
          }
        }
      }
    } catch (e) {
      print("Errore in fetchProfs: $e");
      rethrow;
    }
    return profs;
  }

  Future<List<String>> fetchClassi(String fileUrl) async {
    List<String> classi = [];
    try {
      final response = await dio.get(fileUrl, options: Options(responseType: ResponseType.bytes));
      if (response.statusCode == 200) {

        Uint8List bytes = Uint8List.fromList(response.data);
        var excel = Excel.decodeBytes(bytes);
        for (var table in excel.tables.keys) {
          for (var row in excel.tables[table]!.rows) {

            if (row[1] != null) {
              String value = row[1]!.toString().toLowerCase();
              if (RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z])[a-zA-Z0-9 ]{1,6}\$').hasMatch(value) && !value.contains("lab") && !value.contains("sos") && !classi.contains(value)) {
                classi.add(value);
                print("aggiungo $value");
              }
            }
          }
        }
      }
    } catch (e) {
      print("Errore in fetchClassi: $e");
      rethrow;
    }

    print(classi.toString());
    return classi;
  }
}

void main() async {
  final DataFetcher dataFetcher = DataFetcher();
  const String fileUrl = "https://www.isrosselliaprilia.edu.it/orarioN/orario_dal.xlsx";

  try {
    List<String> profs = await dataFetcher.fetchProfs(fileUrl);
    print("Professori: \$profs");

    List<String> classi = await dataFetcher.fetchClassi(fileUrl);
    print("Classi: \$classi");
  } catch (e) {
    print("Errore durante il recupero delle liste: \$e");
  }
}
