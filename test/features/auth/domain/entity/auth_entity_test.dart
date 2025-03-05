import 'package:flutter_test/flutter_test.dart';
import 'package:vitalflow/features/auth/domain/entity/auth_entity.dart';

void main() {
  group('AuthEntity', () {
    // Test data
    const authEntity1 = AuthEntity(
      userId: '123',
      name: 'suvam khadgi',
      email: 'suvamkhadgi@gmail.com',
      password: 'password123',
      image: 'profile.jpg',
    );

    const authEntity2 = AuthEntity(
      userId: '123',
      name: 'suvam khadgi',
      email: 'suvamkhadgi@gmail.com',
      password: 'password123',
      image: 'profile.jpg',
    );

    const authEntity3 = AuthEntity(
      userId: '456',
      name: 'suvamkhadgiii',
      email: 'suvamkhaddgi@gmail.com',
      password: 'password456',
      image: 'profile2.jpg',
    );

    // Test case 1: Two instances with the same properties should be equal
    test('should be equal when properties are the same', () {
      expect(authEntity1, equals(authEntity2));
    });

    // Test case 2: Two instances with different properties should not be equal
    test('should not be equal when properties are different', () {
      expect(authEntity1, isNot(equals(authEntity3)));
    });

    // Test case 3: Props list should contain all properties
    test('props list should contain all properties', () {
      expect(
        authEntity1.props,
        containsAllInOrder([
          '123', // userId
          'suvam khadgi', // name
          'suvamkhadgi@gmail.com', // email
          'password123', // password
          'profile.jpg', // image
        ]),
      );
    });
  });
}