import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Enterprise API Service for Buyer App
/// Connects to NestJS backend with SQLite/Prisma
class BuyerApiService {
  static const String baseUrl = 'https://projectgenie-api.onrender.com';

  // ─── PROJECTS ──────────────────────────────────────────────────
  static Future<List<dynamic>> getProjects({
    String? domain,
    bool? featured,
  }) async {
    var url = '$baseUrl/projects?';
    if (domain != null && domain != 'All') url += 'domain=$domain&';
    if (featured == true) url += 'featured=true&';
    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getProjects error: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getFeaturedProjects() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/projects/featured'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getFeaturedProjects error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getProject(String id) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/projects/$id'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getProject error: $e');
    }
    return null;
  }

  // ─── SERVICES ──────────────────────────────────────────────────
  static Future<List<dynamic>> getServices({String? category}) async {
    var url = '$baseUrl/services';
    if (category != null) url += '?category=$category';
    try {
      final res = await http
          .get(Uri.parse(url))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getServices error: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getFeaturedServices() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/services/featured'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getFeaturedServices error: $e');
    }
    return [];
  }

  static Future<List<dynamic>> getTrendingServices() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/services/trending'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getTrendingServices error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getService(String id) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/services/$id'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getService error: $e');
    }
    return null;
  }

  // ─── CATEGORIES ────────────────────────────────────────────────
  static Future<List<dynamic>> getCategories() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/categories'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getCategories error: $e');
    }
    return [];
  }

  // ─── ORDERS ────────────────────────────────────────────────────
  static Future<List<dynamic>> getOrders(String userId) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/orders?userId=$userId'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getOrders error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> createOrder(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/orders'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200 || res.statusCode == 201)
        return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API createOrder error: $e');
    }
    return null;
  }

  // ─── CUSTOM ORDERS ─────────────────────────────────────────────
  static Future<List<dynamic>> getCustomOrders(String userId) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/custom-orders?userId=$userId'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getCustomOrders error: $e');
    }
    return [];
  }

  static Future<Map<String, dynamic>?> createCustomOrder(
    Map<String, dynamic> data,
  ) async {
    try {
      final res = await http
          .post(
            Uri.parse('$baseUrl/custom-orders'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200 || res.statusCode == 201)
        return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API createCustomOrder error: $e');
    }
    return null;
  }

  // ─── BUNDLES ───────────────────────────────────────────────────
  static Future<List<dynamic>> getBundles() async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/bundles'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getBundles error: $e');
    }
    return [];
  }

  // ─── USER ──────────────────────────────────────────────────────
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    try {
      final res = await http
          .get(Uri.parse('$baseUrl/users/$userId'))
          .timeout(const Duration(seconds: 60));
      if (res.statusCode == 200) return jsonDecode(res.body);
    } catch (e) {
      debugPrint('API getUser error: $e');
    }
    return null;
  }
}
