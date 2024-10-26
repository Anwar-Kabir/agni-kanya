import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class StateController extends GetxController {
  var states = <Map<String, dynamic>>[].obs;
  var cities = <Map<String, dynamic>>[].obs;
  var zipCode = Rx<String?>(null);
  var selectedState = Rx<String?>(null);
  var selectedCity = Rx<String?>(null);

  final zipController = TextEditingController();


  final String stateApiUrl = 'https://agnikanya.rudraganga.com/api/state';
  final String cityApiUrl = 'https://agnikanya.rudraganga.com/api/city/';
  final String zipApiUrl = 'https://agnikanya.rudraganga.com/api/zip/';

  @override
  void onInit() {
    super.onInit();
    fetchStates();
  }

  // Fetch the list of states
  Future<void> fetchStates() async {
    try {
      final response = await http.get(Uri.parse(stateApiUrl));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        states.assignAll(List<Map<String, dynamic>>.from(data['states']));
      } else {
        throw Exception('Failed to load states');
      }
    } catch (e) {
      print('Error fetching states: $e');
    }
  }

  // Fetch cities based on the selected state ID
  Future<void> fetchCities(String stateId) async {
    try {
      final response = await http.get(Uri.parse('$cityApiUrl$stateId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        cities.assignAll(List<Map<String, dynamic>>.from(data['cities']));
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      print('Error fetching cities: $e');
    }
  }

  // Fetch ZIP code based on the selected city ID
  Future<void> fetchZipCode(String cityId) async {
    try {
      final response = await http.get(Uri.parse('$zipApiUrl$cityId'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Check if the ZIP code data is present and non-empty
        if (data['zip_code'] != null && data['zip_code'].isNotEmpty) {
          zipCode.value = data['zip_code'][0]['code'];
        } else {
          zipCode.value = null;
        }
      } else {
        throw Exception('Failed to load ZIP code');
      }
    } catch (e) {
      zipCode.value = null;
      print('Error fetching ZIP code: $e');
    }
  }

  
  

  // Update the selected state and fetch corresponding cities
  void updateSelectedState(String? state) {
    selectedState.value = state;
    if (state != null) {
      fetchCities(state);
      selectedCity.value = null;
      zipCode.value = null;
    }
  }

  // Update the selected city and fetch corresponding ZIP code
  void updateSelectedCity(String? city) {
    selectedCity.value = city;
    if (city != null) {
      fetchZipCode(city);
    } else {
      zipCode.value = null;
    }
  }
 

}



 