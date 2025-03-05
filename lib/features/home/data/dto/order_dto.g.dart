// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      address: json['address'] as String,
      phoneNo: json['phone_no'] as String,
      cartId: json['cartId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'address': instance.address,
      'phone_no': instance.phoneNo,
      'cartId': instance.cartId,
      'createdAt': instance.createdAt.toIso8601String(),
    };
