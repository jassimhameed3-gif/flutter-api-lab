import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<void> saveUserProfile(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('userProfile', jsonEncode(profile));
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('userProfile');
    if (s != null) return jsonDecode(s);
    return null;
  }

  Future<void> saveAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('userActions') ?? [];
    list.add(action);
    await prefs.setStringList('userActions', list);
  }

  Future<List<String>> getActions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userActions') ?? [];
  }

  Future<void> saveNotification(String n) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> list = prefs.getStringList('notifications') ?? [];
    list.add(n);
    await prefs.setStringList('notifications', list);
  }

  Future<List<String>> getNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('notifications') ?? [];
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}