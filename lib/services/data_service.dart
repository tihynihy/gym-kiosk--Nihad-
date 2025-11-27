import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/member.dart';
import '../models/class_session.dart';

class DataService {
  static Future<List<Member>> loadMembers() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/members.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((json) => Member.fromJson(json)).toList(); 
    } catch (e) {
      print('Error loading members: $e');
      return [];
    }
  }

  static Future<List<ClassSession>> loadClasses() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/classes.json');
      final List<dynamic> jsonData = json.decode(jsonString);
      return jsonData  
          .map((json) => ClassSession.fromJson(json))
          //.where((session) => session.isToday)
          .toList()
        ..sort((a, b) => a.startTime.compareTo(b.startTime));
    } catch (e) {
      print('Error loading classes: $e');
      return [];
    }
  }
}