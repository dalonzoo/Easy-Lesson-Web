import 'package:Easy_Lesson_web/utils/GiornoDetails.dart';

class OrarioSettimanale {
  Map<String, GiornoDetails> giorni;

  OrarioSettimanale({
    required this.giorni,
  });



  factory OrarioSettimanale.fromJson(Map<String, dynamic> json) {
    Map<String, GiornoDetails> giorniMap = {};
    json.forEach((key, value) {
      giorniMap[key] = GiornoDetails.fromJson(value);
    });

    return OrarioSettimanale(
      giorni: giorniMap,
    );
  }




  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    giorni.forEach((key, value) {
      json[key] = (value as GiornoDetails).toJson();
    });
    return json;
  }
}
