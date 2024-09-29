


import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:woman_safety/models/sos_history_model.dart';

class SosHistoryController extends GetxController{


  var isLoading=false.obs;

  RxList<NearestPoliceStations> sos_history=<NearestPoliceStations>[].obs;
  getHitory()async{
    isLoading.value=true;
    const apiUrl = 'https://test.shuvobhowmik.xyz/api/sos-history';


    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      //String accessToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Rlc3Quc2h1dm9iaG93bWlrLnh5ei9hcGkvdmVyaWZ5LW90cCIsImlhdCI6MTcyNjg2NzIzMCwiZXhwIjoxNzQyNDE5MjMwLCJuYmYiOjE3MjY4NjcyMzAsImp0aSI6IktmeENHTURBSWp6VFBlbDciLCJzdWIiOiI5ZDBiYWM3Ny02MDRmLTQ5ZGItYWJlMi1hMmFjNTMxYmI3MDEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.ngpbCfZu4TtWsBsEp1WrcdCDcsMVStEwjPFYn0eCADo";
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json",'Authorization': 'Bearer $accessToken',},

      );
      log("Sos Repon",error: response.body);
      log("statuc code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data=SosHistoy.fromJson(jsonDecode(response.body));
        sos_history.value=data.history!.nearestPoliceStations!;
        isLoading.value=false;
        print('so get successfully');
      } else {
        print('sos failed code $response');
        isLoading.value=false;
      }
    } catch (e) {
      print('sos failed: $e');
      isLoading.value=false;
    }
  }

}