import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/check_in.dart';

class CheckInService {
  static const String _checkInsKey = 'check_ins'; 

  Future<List<CheckIn>> getCheckIns() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? checkInsJson = prefs.getString(_checkInsKey);
      
      if (checkInsJson == null || checkInsJson.isEmpty) return [];

      final List<dynamic> jsonList = json.decode(checkInsJson);
      return jsonList.map((json) => CheckIn.fromJson(json)).toList();
    } catch (e) {
      print('Error loading check-ins: $e');
      return [];
    }
  }

  Future<List<CheckIn>> getCheckInsForClass(String classSessionId) async {
    final allCheckIns = await getCheckIns();
    return allCheckIns
        .where((checkIn) => checkIn.classSessionId == classSessionId)
        .toList();
  }

  Future<bool> addCheckIn(CheckIn checkIn) async {
    try {
      final allCheckIns = await getCheckIns();
      allCheckIns.add(checkIn);

      final prefs = await SharedPreferences.getInstance(); 
      final String checkInsJson = json.encode(
        allCheckIns.map((ci) => ci.toJson()).toList(),
      );
      await prefs.setString(_checkInsKey, checkInsJson);  
      return true;
    } catch (e) {
      print('Error adding check-in: $e');
      return false;
    }
  }

  Future<bool> hasCheckedIn(String memberId, String classSessionId) async {
    final checkIns = await getCheckInsForClass(classSessionId);
    return checkIns.any((ci) => ci.memberId == memberId);
  }
}