import 'package:ZmrzlinaApi/api.dart';
import 'package:flutter/material.dart';

class ApiUtils {
  ///NEW Api calls///
  final response = CustomerApi();

  Future<void> fetchDailyMenu() async {
    try {
      var data = await response.getToday(); // Await the API call
      debugPrint("Fetched Data: $data"); // Print the result after fetching
    } catch (e) {
      debugPrint("Error fetching data: $e"); // Print any errors
    }
  }

  ///NEW Api calls///
}
