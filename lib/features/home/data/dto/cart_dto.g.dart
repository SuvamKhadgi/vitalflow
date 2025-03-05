// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDto _$CartDtoFromJson(Map<String, dynamic> json) => CartDto(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CartDtoToJson(CartDto instance) => <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'items': instance.items,
    };

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
      itemId: _itemIdFromJson(json['itemId']),
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'itemId': instance.itemId,
      'quantity': instance.quantity,
    };
