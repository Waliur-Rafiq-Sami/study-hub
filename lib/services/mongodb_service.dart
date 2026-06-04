import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MongoDBService {
  static const String mongoUrl = "mongodb+srv://waliurrafiqsami_db_user:jmLJOfHerPDnAJ6F@cluster0.czdikna.mongodb.net/studyhub?retryWrites=true&w=majority";
  
  static Db? _db;
  static Map<String, dynamic>? currentUser;
  static bool isConnected = false;

  static Future<void> connect() async {
    if (_db != null && _db!.isConnected) return;
    
    try {
      log("Connecting to MongoDB...");
      _db = await Db.create(mongoUrl);
      await _db!.open();
      isConnected = _db!.isConnected;
      log("DATABASE CONNECTED: $isConnected");
      await loadSession();
    } catch (e) {
      log("DATABASE CONNECTION ERROR: $e");
      isConnected = false;
    }
  }

  static Future<void> saveSession(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    currentUser = sanitize(user);
    await prefs.setString('user_session', jsonEncode(currentUser));
  }

  static Future<void> loadSession() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('user_session');
    if (data != null) {
      currentUser = jsonDecode(data);
    }
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_session');
    currentUser = null;
  }

  static Map<String, dynamic> sanitize(Map<String, dynamic> data) {
    var map = Map<String, dynamic>.from(data);
    if (map.containsKey('_id') && map['_id'] is ObjectId) {
      map['_id'] = (map['_id'] as ObjectId).toHexString();
    }
    return map;
  }

  static DbCollection getCollection(String name) {
    if (_db == null || !_db!.isConnected) {
      throw "Database is not connected. Please wait or restart the app.";
    }
    return _db!.collection(name);
  }

  // Helper getters
  static SelectorBuilder get where => SelectorBuilder();
  static ModifierBuilder get modify => ModifierBuilder();
  static ObjectId parseId(String id) => ObjectId.fromHexString(id);
}
