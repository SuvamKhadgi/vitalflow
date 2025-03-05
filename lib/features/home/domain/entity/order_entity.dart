import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String? id;
  final String userId;
  final String address;
  final String phoneNo;
  final String? cartId;
  final DateTime createdAt;

  const OrderEntity({
    this.id,
    required this.userId,
    required this.address,
    required this.phoneNo,
    this.cartId,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'address': address,
      'phone_no': phoneNo,
      'cartId': cartId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, userId, address, phoneNo, cartId, createdAt];
}