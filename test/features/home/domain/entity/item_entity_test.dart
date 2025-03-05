import 'package:flutter_test/flutter_test.dart';
import 'package:vitalflow/features/home/domain/entity/item_entity.dart';

void main() {
  test('ItemEntity creates with all required fields', () {
    final item = ItemEntity(
      id: '1',
      name: 'Test Item',
      description: 'Test Desc',
      price: 10.0,
      quantity: 5,
      type: 'Test Type',
      subType: 'Test SubType',
      image: 'test.jpg',
    );
    expect(item.id, '1');
    expect(item.name, 'Test Item');
    expect(item.cartQuantity, 0);
  });

  test('ItemEntity copyWith updates cartQuantity', () {
    final item = ItemEntity(
      id: '1',
      name: 'Test Item',
      description: 'Test Desc',
      price: 10.0,
      quantity: 5,
      type: 'Test Type',
      subType: 'Test SubType',
      image: 'test.jpg',
    );
    final updated = item.copyWith(cartQuantity: 3);
    expect(updated.cartQuantity, 3);
    expect(updated.id, '1'); // Other fields unchanged
  });
}