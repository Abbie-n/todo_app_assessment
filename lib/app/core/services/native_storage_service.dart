import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:riverpod/riverpod.dart';
import 'package:todo_app_assessment/app/core/custom_printer.dart';

final nativeStorageServiceProvider = Provider<NativeStorageService>(
  (ref) => NativeStorageService(),
);

@lazySingleton
class NativeStorageService {
  static late NativeStorageService _instance;

  factory NativeStorageService() {
    _instance = NativeStorageService._internal();
    return _instance;
  }

  NativeStorageService._internal();

  static const MethodChannel _channel = MethodChannel(
    'com.todo_app_assessment/offline_storage',
  );

  Future<List<Map<String, dynamic>>> getAllTodos() async {
    try {
      final result = await _channel.invokeMethod('getAllTodos');
      final List<dynamic> list = result as List<dynamic>;
      return list.map((item) => Map<String, dynamic>.from(item)).toList();
    } on PlatformException catch (e) {
      error("Failed to get todos: ${e.message}");
      return [];
    }
  }

  Future<bool> saveTodo(Map<String, dynamic> todo) async {
    try {
      return await _channel.invokeMethod('saveTodo', todo);
    } on PlatformException catch (e) {
      error("Failed to save todo: ${e.message}");
      return false;
    }
  }

  Future<bool> updateTodo(Map<String, dynamic> todo) async {
    try {
      return await _channel.invokeMethod('updateTodo', todo);
    } on PlatformException catch (e) {
      error("Failed to update todo: ${e.message}");
      return false;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      return await _channel.invokeMethod('deleteTodo', id);
    } on PlatformException catch (e) {
      error("Failed to delete todo: ${e.message}");
      return false;
    }
  }
}
