import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/member.dart';
import '../models/class_session.dart';

class DataService {
    static Future<List<Member>> loadMembers() async {
        try {
            final String jsonString = await rootBundle.loadString('assets/data/members.json');
            final List<dynamic> jsonData = jsonDecode(jsonString);
            return jsonList.map((json) => Member.fromJson(json)).toList();
        } catch (e) {
            throw Exception('Failed to load members: $e');
        }
    }

    static Future<List<ClassSession>> loadClasses() async {
        try {
            final String jsonString = await rootBundle.loadString('assets/data/classes.json');
            final List<dynamic> jsonData = jsonDecode(jsonString);
            return jsonList 
            .map((json) => ClassSession.fromJson(json))
            .where((session) => session.isToday)
            .toList()
            ..sort((a, b) => a.startTime.compareTo(b.startTime));
        } catch (e) {
            throw Exception('Failed to load classes: $e');
        }
    }
}