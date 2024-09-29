
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Apiservice{
   static getFriendFamilyDetails()async{
    print("Data is calling.....");
    
    try{

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      String? userID=prefs.getString("user_id");
      print("userid: $userID");
      print("acces: $accessToken");
      final famillyurl="https://test.shuvobhowmik.xyz/api/find-family/$userID";
      final frindUrl="https://test.shuvobhowmik.xyz/api/find-friend/$userID";
     //String accessToken="eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3Rlc3Quc2h1dm9iaG93bWlrLnh5ei9hcGkvdmVyaWZ5LW90cCIsImlhdCI6MTcyNjg2NzIzMCwiZXhwIjoxNzQyNDE5MjMwLCJuYmYiOjE3MjY4NjcyMzAsImp0aSI6IktmeENHTURBSWp6VFBlbDciLCJzdWIiOiI5ZDBiYWM3Ny02MDRmLTQ5ZGItYWJlMi1hMmFjNTMxYmI3MDEiLCJwcnYiOiIyM2JkNWM4OTQ5ZjYwMGFkYjM5ZTcwMWM0MDA4NzJkYjdhNTk3NmY3In0.ngpbCfZu4TtWsBsEp1WrcdCDcsMVStEwjPFYn0eCADo";
      final famillyresponse = await http.get(
        Uri.parse(famillyurl),
        headers: {"Content-Type": "application/json",'Authorization': 'Bearer $accessToken',},
      );
      final friendresponse = await http.get(
        Uri.parse(frindUrl),
        headers: {"Content-Type": "application/json",'Authorization': 'Bearer $accessToken',},
      );
      if(famillyresponse.statusCode==200){
        final data=jsonDecode(famillyresponse.body)["data"] as List;
        if(data.isNotEmpty){
          print("familly data is here");
          return true;
        }

      }
      if(friendresponse.statusCode==200){
        final data=jsonDecode(famillyresponse.body)["data"] as List;
        if(data.isNotEmpty){
          print("friends data is here");
          return true;
        }
      }
      return false;
    }catch (e){
      return false;
    }
  }



  static  Future fetchPersonalInfo() async {
    print("data is calling................................................");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accessToken = prefs.getString('access_token');
      //String? userId = prefs.getString('user_id');


      final url = Uri.parse('https://test.shuvobhowmik.xyz/api/personal-info');
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data != null && data['personal_info'] != null) {

          await prefs.setString("user_id", data["personal_info"]["id"]);
          if(data["personal_info"]["email"]==null){
            return true;
          }
        } else {

        }
      } else {

      }
    } catch (error) {

    }
  }
}