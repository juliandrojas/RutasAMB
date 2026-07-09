import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/history_repository.dart';
import '../../../../core/constants/app_constants.dart';

class HiveHistoryRepositoryImpl implements HistoryRepository {
  static const _key = 'search_history';

  Future<SharedPreferences> get _prefs => SharedPreferences.getInstance();

  @override
  Future<List<SearchHistoryEntry>> getHistory() async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    return raw
        .map((s) => SearchHistoryEntry.fromJson(jsonDecode(s) as Map<String, dynamic>))
        .toList()
        .reversed
        .toList();
  }

  @override
  Future<void> addEntry(SearchHistoryEntry entry) async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    raw.add(jsonEncode(entry.toJson()));
    if (raw.length > AppConstants.maxHistoryItems) raw.removeAt(0);
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<void> removeEntry(int index) async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_key) ?? [];
    // index viene del reversed, convertir al real
    final realIdx = raw.length - 1 - index;
    if (realIdx >= 0 && realIdx < raw.length) raw.removeAt(realIdx);
    await prefs.setStringList(_key, raw);
  }

  @override
  Future<void> clearHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_key);
  }
}
