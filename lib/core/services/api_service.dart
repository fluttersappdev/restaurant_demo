import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import '../utils/helpers.dart';
import '../../models/restaurant.dart';

class ApiService {
  final Dio _dio = Dio();

  Future<List<Restaurant>> getRestaurants() async {
    try {
      // In a real app, this would be an actual API call
      // For this demo, we'll load from local assets
      final String response = await rootBundle.loadString('assets/data/restaurants.json');
      final data = json.decode(response);

      List<Restaurant> restaurants = [];
      for (var item in data['restaurants']) {
        restaurants.add(Restaurant.fromJson(item));
      }

      return restaurants;
    } catch (e) {
      print('Error fetching restaurants: $e');
      return [];
    }
  }

  // Mock API call to simulate network request
  Future<List<Restaurant>> getRestaurantsFromApi() async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      // In a real app, this would be an actual API call
      // For this demo, we'll load from local assets
      final String response = await rootBundle.loadString('assets/data/restaurants.json');
      final data = json.decode(response);

      List<Restaurant> restaurants = [];
      for (var item in data['restaurants']) {
        restaurants.add(Restaurant.fromJson(item));
      }

      return restaurants;
    } catch (e) {
      print('Error fetching restaurants from API: $e');
      return [];
    }
  }
}