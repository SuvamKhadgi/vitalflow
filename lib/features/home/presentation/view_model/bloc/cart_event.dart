abstract class CartEvent {}

class FetchCartEvent extends CartEvent {}

class IncreaseQuantity extends CartEvent {
  final String itemId;
  IncreaseQuantity(this.itemId);
}

class DecreaseQuantity extends CartEvent {
  final String itemId;
  DecreaseQuantity(this.itemId);
}