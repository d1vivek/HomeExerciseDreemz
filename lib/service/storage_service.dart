import 'package:encrypt/encrypt.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class StorageService extends GetxService {
  late dynamic iv;
  late Encrypter encrypter;

  init() async {
    await GetStorage.init(StorageBox.secureBox);
    await GetStorage.init(StorageBox.unsecureBox);
    String key = "tKXR6T1ZvrlXfvpt";
    iv = IV.fromUtf8(key);
    encrypter = Encrypter(AES(Key.fromUtf8(key), padding: null));
  }

  GetStorage _getContainer(String name) {
    return GetStorage(name);
  }

  GetStorage getCacheContainer(String name) {
    return GetStorage(name);
  }

  Future deleteBox(String name) {
    return _getContainer(name).erase();
  }

  void put(String key, dynamic value, {String boxName = StorageBox.secureBox}) {
    if (boxName != StorageBox.secureBox) {
      _getContainer(boxName).write(key, value);
    } else {
      _getContainer(boxName).write(key, encrypter.encrypt(value.toString(), iv: iv).base64);
    }
  }

  T get<T>(String key, T defVal, {String boxName = StorageBox.secureBox}) {
    final record = _getContainer(boxName).read(key);
    if (record == null) {
      return defVal;
    }
    if (boxName != StorageBox.secureBox) {
      return record as T;
    } else {
      if (T == bool) {
        return bool.parse(encrypter.decrypt(Encrypted.from64(record), iv: iv)) as T;
      } else {
        return encrypter.decrypt(Encrypted.from64(record), iv: iv) as T;
      }
    }
  }

  void remove(String key, {String boxName = StorageBox.secureBox}) {
    _getContainer(boxName).remove(key);
  }
}

final class StorageBox {
  StorageBox._();

  static const String secureBox = "secureBox";
  static const String unsecureBox = "unsecureBox";
}

final class StorageKey {
  StorageKey._();

  static const String favList = "favList";
}
