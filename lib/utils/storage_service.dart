import 'package:get_storage/get_storage.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  late GetStorage _box;

  factory StorageService() {
    return _instance;
  }

  StorageService._internal();


  Future<void> init() async {
    await GetStorage.init();
    _box = GetStorage();
  }


  static const String keyHasSeenOnboarding = "hasSeenOnboarding";

  void write(String key, dynamic value) => _box.write(key, value);
  dynamic read(String key) => _box.read(key);
  bool hasData(String key) => _box.hasData(key);
  void remove(String key) => _box.remove(key);

  bool get hasSeenOnboarding => _box.read(keyHasSeenOnboarding) ?? false;
  void setHasSeenOnboarding(bool value) =>
      _box.write(keyHasSeenOnboarding, value);
}
