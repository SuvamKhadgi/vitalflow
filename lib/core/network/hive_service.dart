import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vitalflow/app/constants/hive_table_constant.dart';
import 'package:vitalflow/features/auth/data/model/auth_hive_model.dart';
import 'package:vitalflow/features/home/data/model/item_hive_model.dart';
import 'package:vitalflow/features/home/data/model/cart_hive_model.dart';
import 'package:vitalflow/features/home/data/model/order_hive_model.dart';

class HiveService {
  late Box<AuthHiveModel> _userBox;
  late Box<ItemHiveModel> _itemsBox;
  late Box<CartHiveModel> _cartBox;
  late Box<OrderHiveModel> _ordersBox;

  // Singleton instance
  static final HiveService _instance = HiveService._internal();
  static bool _isInitialized = false;

  factory HiveService() {
    return _instance;
  }

  HiveService._internal();

  static Future<void> init() async {
    if (_isInitialized) {
      print('HiveService already initialized, skipping...');
      return;
    }

    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}vitalflow.db';
    Hive.init(path);

    try {
      print('Registering AuthHiveModelAdapter (typeId: 0)');
      Hive.registerAdapter(AuthHiveModelAdapter());
      print('Registering ItemHiveModelAdapter (typeId: 1)');
      Hive.registerAdapter(ItemHiveModelAdapter());
      print('Registering CartHiveModelAdapter (typeId: 2)');
      Hive.registerAdapter(CartHiveModelAdapter());
      print('Registering CartItemHiveModelAdapter (typeId: 3)');
      Hive.registerAdapter(CartItemHiveModelAdapter());
      print('Registering OrderHiveModelAdapter (typeId: 4)');
      Hive.registerAdapter(OrderHiveModelAdapter());
    } catch (e) {
      print('Error registering adapters: $e');
      rethrow;
    }

    _instance._userBox = await Hive.openBox<AuthHiveModel>(HiveTableConstant.userBox);
    _instance._itemsBox = await Hive.openBox<ItemHiveModel>('itemsBox');
    _instance._cartBox = await Hive.openBox<CartHiveModel>('cartBox');
    _instance._ordersBox = await Hive.openBox<OrderHiveModel>('ordersBox');

    _isInitialized = true;
    print('HiveService initialization complete');
  }

  // Auth Methods
  Future<void> register(AuthHiveModel auth) async {
    await _userBox.put(auth.usersId, auth);
  }

  Future<AuthHiveModel?> login(String email, String password) async {
    return _userBox.values.firstWhere(
      (element) => element.email == email && element.password == password,
      orElse: () => throw Exception('User not found'),
    );
  }

  // Item Methods
  Future<void> saveItems(List<ItemHiveModel> items) async {
    await _itemsBox.clear();
    for (var item in items) {
      await _itemsBox.put(item.id, item);
    }
  }

  Future<List<ItemHiveModel>> getItems() async {
    return _itemsBox.values.toList();
  }

  // Cart Methods
  Future<void> saveCart(CartHiveModel cart) async {
    print('Saving cart to Hive: userId=${cart.userId}, items=${cart.items.length}');
    await _cartBox.put(cart.userId, cart);
  }

  Future<CartHiveModel?> getCart(String userId) async {
    return _cartBox.get(userId);
  }

  // Order Methods
  Future<void> saveOrders(List<OrderHiveModel> orders) async {
    await _ordersBox.clear();
    for (var order in orders) {
      await _ordersBox.put(order.id, order);
    }
  }

  Future<List<OrderHiveModel>> getOrders() async {
    return _ordersBox.values.toList();
  }

  Future<void> clearAll() async {
    await _userBox.clear();
    await _itemsBox.clear();
    await _cartBox.clear();
    await _ordersBox.clear();
  }

  Future<void> close() async {
    await _userBox.close();
    await _itemsBox.close();
    await _cartBox.close();
    await _ordersBox.close();
    _isInitialized = false; // Reset for next init if needed
  }
}