

class PolishModel {
  List<NearestPoliceStations>? nearestPoliceStations;

  PolishModel(
      { this.nearestPoliceStations});

  PolishModel.fromJson(Map<String, dynamic> json) {
    if (json['nearest_police_stations'] != null) {
      nearestPoliceStations = <NearestPoliceStations>[];
      json['nearest_police_stations'].forEach((v) {
        nearestPoliceStations!.add(NearestPoliceStations.fromJson(v));
        nearestPoliceStations!.add(  NearestPoliceStations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (nearestPoliceStations != null) {
      data['nearest_police_stations'] =
          nearestPoliceStations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Location {
  String? plusCode;
  String? route;
  String? locality;
  String? district;
  String? division;
  String? country;

  Location(
      {this.plusCode,
      this.route,
      this.locality,
      this.district,
      this.division,
      this.country});

  Location.fromJson(Map<String, dynamic> json) {
    plusCode = json['plus_code'];
    route = json['route'];
    locality = json['locality'];
    district = json['district'];
    division = json['division'];
    country = json['country'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['plus_code'] = plusCode;
    data['route'] = route;
    data['locality'] = locality;
    data['district'] = district;
    data['division'] = division;
    data['country'] = country;
    return data;
  }
}

class NearestPoliceStations {
  String? name;
  String? address;
  Locations? location;
  String? rating;
  String? placeId;
  String? phoneNumber;

  NearestPoliceStations(
      {this.name,
      this.address,
      this.location,
      this.rating,
      this.placeId,
      this.phoneNumber});

  NearestPoliceStations.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    address = json['address'];
    location = json['location'] != null
        ?  Locations.fromJson(json['location'])
        : null;
    rating = json['rating'].toString();
    placeId = json['place_id'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['address'] = address;
    if (location != null) {
      data['location'] = location!.toJson();
    }
    data['rating'] = rating;
    data['place_id'] = placeId;
    data['phone_number'] = phoneNumber;
    return data;
  }
}

class Locations {
  double? lat;
  double? lng;

  Locations({this.lat, this.lng});

  Locations.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['lng'] = lng;
    return data;
  }
}
