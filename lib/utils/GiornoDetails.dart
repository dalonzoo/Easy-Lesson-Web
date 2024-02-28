class GiornoDetails {
  String ora1;
  String ora2;
  String ora3;
  String ora4;
  String ora5;
  String ora6;
  String ora7;
  String ora8;
  String ora9;
  String ora10;
  String oreGiorno;
  int nOre;
  int nOreProf;
  String laboratorio;
  String lab1;
  String lab2;
  String lab3;
  String lab4;
  String lab5;
  String lab6;
  String lab7;
  String lab8;
  String lab9;
  String lab10;
  List<dynamic> sostegno;
  List<dynamic> lezioni;

  GiornoDetails({
    required this.ora1,
    required this.ora2,
    required this.ora3,
    required this.ora4,
    required this.ora5,
    required this.ora6,
    required this.ora7,
    required this.ora8,
    required this.ora9,
    required this.ora10,
    required this.oreGiorno,
    required this.nOre,
    required this.nOreProf,
    required this.laboratorio,
    required this.lab1,
    required this.lab2,
    required this.lab3,
    required this.lab4,
    required this.lab5,
    required this.lab6,
    required this.lab7,
    required this.lab8,
    required this.lab9,
    required this.lab10,
    required this.lezioni,
    required this.sostegno
  });

  factory GiornoDetails.fromJson(Map<String, dynamic> json) {
    return GiornoDetails(
      ora1: json['ora1'],
      ora2: json['ora2'],
      ora3: json['ora3'],
      ora4: json['ora4'],
      ora5: json['ora5'],
      ora6: json['ora6'],
      ora7: json['ora7'],
      ora8: json['ora8'],
      ora9: json['ora9'],
      ora10: json['ora10'],
      oreGiorno: json['oreGiorno'],
      nOre: json['nOre'],
      nOreProf: json['nOreProf'],
      laboratorio: json['laboratorio'],
      lab1: json['lab1'],
      lab2: json['lab2'],
      lab3: json['lab3'],
      lab4: json['lab4'],
      lab5: json['lab5'],
      lab6: json['lab6'],
      lab7: json['lab7'],
      lab8: json['lab8'],
      lab9: json['lab9'],
      lab10: json['lab10'],
      lezioni: json['lezioni'],
      sostegno: json['sostegno']
    );
  }

  String getOra(int num){
    switch(num){
      case 0:
        return this.ora1;
        break;
      case 1:
        return this.ora2;
      case 2:
        return this.ora3;
      case 3:
        return this.ora4;
      case 4:
        return this.ora5;
      case 5:
        return this.ora6;
      case 6:
        return this.ora7;
      case 7:
        return this.ora8;
      case 8:
        return this.ora9;
      case 9:
        return this.ora10;
      default:
        return "";
        break;

    }


  }

  String getLab(int num){
    switch(num){
      case 0:
        return this.lab1;
        break;
      case 1:
        return this.lab2;
      case 2:
        return this.lab3;
      case 3:
        return this.lab4;
      case 4:
        return this.lab5;
      case 5:
        return this.lab6;
      case 6:
        return this.lab7;
      case 7:
        return this.lab8;
      case 8:
        return this.lab9;
      case 9:
        return this.lab10;
      default:
        return "";
        break;
    }
  }


  Map<String, dynamic> toJson() {
    return {
      'ora1': ora1,
      'ora2': ora2,
      'ora3': ora3,
      'ora4': ora4,
      'ora5': ora5,
      'ora6': ora6,
      'ora7': ora7,
      'ora8': ora8,
      'ora9': ora9,
      'ora10': ora10,
      'oreGiorno': oreGiorno,
      'nOre': nOre,
      'nOreProf': nOreProf,
      'laboratorio': laboratorio,
      'lab1': lab1,
      'lab2': lab2,
      'lab3': lab3,
      'lab4': lab4,
      'lab5': lab5,
      'lab6': lab6,
      'lab7': lab7,
      'lab8': lab8,
      'lab9': lab9,
      'lab10': lab10,
      'lezioni': lezioni,
      'sostegno' : sostegno
    };
  }

}
