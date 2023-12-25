class Utils {
  static Map<String, String> translated(Map<String, String> map) => map.map((key, value) => MapEntry(key.toLowerCase().substring(0, 2), value));
}