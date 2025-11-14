import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService {
  static const String _key = 'bookmark';

  static Future<void> saveBookMark(Set<String> id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, id.toList());
  }

  static Future<Set<String>> getBookMark() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  static Future<void> toggleBookmark(String id) async {
    final current = await getBookMark();
    if (current.contains(id)) {
      current.remove(id);
    } else {
      current.add(id);
    }
    await saveBookMark(current);
  }
}
