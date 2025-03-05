import 'package:json_annotation/json_annotation.dart';
import 'package:vitalflow/features/home/domain/entity/order_entity.dart';

part 'order_dto.g.dart';

@JsonSerializable()
class OrderDto {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  final String address;
  @JsonKey(name: 'phone_no')
  final String phoneNo;
  final String? cartId;
  final DateTime createdAt;

  OrderDto({
    this.id,
    required this.userId,
    required this.address,
    required this.phoneNo,
    this.cartId,
    required this.createdAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);

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