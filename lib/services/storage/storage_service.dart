abstract class LocalStorageService {
  Future<void> put(String key, String value);
  Future<dynamic> get(String key);
  Future<void> delete(String key);
  Future<void> clear();
}
