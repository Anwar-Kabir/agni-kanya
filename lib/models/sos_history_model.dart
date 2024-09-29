
class SosHistoy {
  History? history;

  SosHistoy({this.history});

  SosHistoy.fromJson(Map<String, dynamic> json) {
    history =
    json['history'] != null ? new History.fromJson(json['history']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.history != null) {
      data['history'] = this.history!.toJson();
    }
    return data;
  }
}

class History {

  List<NearestPoliceStations>? nearestPoliceStations;

  History(
      {
        this.nearestPoliceStations,
      });

  History.fromJson(Map<String, dynamic> json) {
    if (json['nearest_police_stations'] != null) {
      nearestPoliceStations = <NearestPoliceStations>[];
      json['nearest_police_stations'].forEach((v) {
        nearestPoliceStations!.add(new NearestPoliceStations.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.nearestPoliceStations != null) {
      data['nearest_police_stations'] =
          this.nearestPoliceStations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class NearestPoliceStations {
  String? name;
  String? address;
  Location? location;
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
        ? new Location.fromJson(json['location'])
        : null;
    rating = json['rating'].toString();
    placeId = json['place_id'];
    phoneNumber = json['phone_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['address'] = this.address;
    if (this.location != null) {
      data['location'] = this.location!.toJson();
    }
    data['rating'] = this.rating;
    data['place_id'] = this.placeId;
    data['phone_number'] = this.phoneNumber;
    return data;
  }
}

class Location {
  double? lat;
  double? lng;

  Location({this.lat, this.lng});

  Location.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}
