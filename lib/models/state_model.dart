class State {
  final int id;
  final String name;
  final List<City> cities;

  State({required this.id, required this.name, required this.cities});

  factory State.fromJson(Map<String, dynamic> json) {
    var list = json['cities'] as List;
    List<City> citiesList = list.map((i) => City.fromJson(i)).toList();
    return State(
      id: json['id'],
      name: json['name'],
      cities: citiesList,
    );
  }
}


class City {
  final int id;
  final String name;
  final List<ZipCode> zipCodes;

  City({required this.id, required this.name, required this.zipCodes});

  factory City.fromJson(Map<String, dynamic> json) {
    var list = json['zip_codes'] as List;
    List<ZipCode> zipCodesList = list.map((i) => ZipCode.fromJson(i)).toList();
    return City(
      id: json['id'],
      name: json['name'],
      zipCodes: zipCodesList,
    );
  }
}


class ZipCode {
  final int id;
  final String code;

  ZipCode({required this.id, required this.code});

  factory ZipCode.fromJson(Map<String, dynamic> json) {
    return ZipCode(
      id: json['id'],
      code: json['code'],
    );
  }
}
