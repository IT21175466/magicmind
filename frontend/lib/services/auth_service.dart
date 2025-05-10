import 'package:magicmind_puzzle/constants/constant.dart';
import 'package:magicmind_puzzle/utils/encript_helper.dart';
import 'package:mongo_dart/mongo_dart.dart';

class MongoService {
  static const _connectionString = MONGO_URL;
  static const _collectionName = "Users";

  static Future<DbCollection> _getCollection() async {
    final db = await Db.create(_connectionString);
    await db.open();
    return db.collection(_collectionName);
  }

  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final col = await _getCollection();
    final user = await col.findOne({'email': email});
    if (user != null) {
      final decrypted = EncryptionHelper.decrypt(user['password']);
      if (decrypted == password) return user;
    }
    return null;
  }

  static Future<ObjectId?> register(
      String email, String password, String name) async {
    final col = await _getCollection();
    final existing = await col.findOne({'email': email});
    if (existing != null) return null;

    final encryptedPassword = EncryptionHelper.encrypt(password);
    final result = await col.insertOne({
      'name': name,
      'email': email,
      'password': encryptedPassword,
    });
    return result.id as ObjectId?;
  }
}
