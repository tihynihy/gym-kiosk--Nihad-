import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/check_in.dart';

class CheckInService {
    static const String __checkInKey = 'check_ins';

    Future<List<CheckIn>> getCheckIns() async {
        try {
            final prefs = await SharedPreferences.getInstance();
            final String? checkInsJson = prefs.getString(__checkInKey);
            
            if (checkInsJson == null || checkInsJson.isEmpty) return [];

            final List<dynamic> jsonList = jsonDecode(checkInsJson);
            return jsonList.map((json) => CheckIn.fromJson(json)).toList();
        } catch (e) {
            throw Exception('Failed to load check-ins: $e');
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

            final pres = await SharedPreferences.getInstance();
            final String checkInsJson = json.encode(
                allCheckIns.map((ci) => ci.toJson()).toList(),
            );
            await prefs.setString(__checkInKey, checkInsJson);
            return true;
        } catch (e) {
            throw Exception('Failed to add check-in: $e');
            return false;
        }   
    }

    Future<bool> hasCheckedIn(String memberId, String classSessionId) async {
        final checkIns = await getCheckInsForClass(classSessionId);
        return checkIns.any((ci) => ci.memberId == memberId);
    }
}