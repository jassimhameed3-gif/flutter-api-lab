import 'package:flutter/material.dart';
import 'storage_service.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StorageService _storage = StorageService();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  String savedProfile = 'No profile saved yet';
  List<String> actions = [];
  List<String> notifications = [];

  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  Future<void> _loadAll() async {
    final profile = await _storage.getUserProfile();
    final a = await _storage.getActions();
    final n = await _storage.getNotifications();
    setState(() {
      if (profile != null) {
        savedProfile = 'Name: ${profile['name']}, Email: ${profile['email']}';
        nameController.text = profile['name'];
        emailController.text = profile['email'];
      }
      actions = a;
      notifications = n;
    });
  }

  Future<void> _saveProfile() async {
    await _storage.saveUserProfile({
      'name': nameController.text,
      'email': emailController.text,
    });
    await _storage.saveAction('Saved profile: ${nameController.text}');
    await _storage.saveNotification('Profile updated for ${nameController.text}');
    _loadAll();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Persistence Lab - Local Storage')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              const SizedBox(height: 10),
              ElevatedButton(onPressed: _saveProfile, child: const Text('Save Profile')),
              ElevatedButton(
                onPressed: () async {
                  await _storage.clearAll();
                  _loadAll();
                },
                child: const Text('Clear All'),
              ),
              const SizedBox(height: 20),
              Text('Saved Data: $savedProfile', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              const Text('User Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...actions.map((e) => Text('- $e')),
              const SizedBox(height: 20),
              const Text('Notifications:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...notifications.map((e) => Text('- $e')),
            ],
          ),
        ),
      ),
    );
  }
}