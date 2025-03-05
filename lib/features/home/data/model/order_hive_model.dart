import 'package:hive/hive.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';

part 'order_hive_model.g.dart';

@HiveType(typeId: 4)
class OrderHiveModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String userId;
  @HiveField(2)
  final String address;
  @HiveField(3)
  final String phoneNo;
  @HiveField(4)
  final String? cartId;
  @HiveField(5)
  final DateTime createdAt;

  OrderHiveModel({
    this.id,
    required this.userId,
    required this.address,
    required this.phoneNo,
    this.cartId,
    required this.createdAt,
  });

  factory OrderHiveModel.fromEntity(OrderEntity entity) {
    return OrderHiveModel(
      id: entity.id,
      userId: entity.userId,
      address: entity.address,
      phoneNo: entity.phoneNo,
      cartId: entity.cartId,
      createdAt: entity.createdAt,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      address: address,
      phoneNo: phoneNo,
      cartId: cartId,
      createdAt: createdAt,
    );
  }
}