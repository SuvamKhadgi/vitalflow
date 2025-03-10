// Mocks generated by Mockito 5.4.5 from annotations
// in vitalflow/test/features/home/domain/use_case/delete_cart_item_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:dartz/dartz.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:vitalflow/core/error/failure.dart' as _i5;
import 'package:vitalflow/features/home/data/repository/cart_repository.dart'
    as _i3;
import 'package:vitalflow/features/home/domain/entity/cart_entity.dart' as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeEither_0<L, R> extends _i1.SmartFake implements _i2.Either<L, R> {
  _FakeEither_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ICartRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockICartRepository extends _i1.Mock implements _i3.ICartRepository {
  MockICartRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Either<_i5.Failure, List<_i6.CartEntity>>> getAllCarts() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllCarts,
          [],
        ),
        returnValue:
            _i4.Future<_i2.Either<_i5.Failure, List<_i6.CartEntity>>>.value(
                _FakeEither_0<_i5.Failure, List<_i6.CartEntity>>(
          this,
          Invocation.method(
            #getAllCarts,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, List<_i6.CartEntity>>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>> saveCart(
    String? userId,
    List<Map<String, dynamic>>? items,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveCart,
          [
            userId,
            items,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.CartEntity>(
          this,
          Invocation.method(
            #saveCart,
            [
              userId,
              items,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>> getCartByUserId(
          String? userId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCartByUserId,
          [userId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.CartEntity>(
          this,
          Invocation.method(
            #getCartByUserId,
            [userId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, void>> deleteCart(String? cartId) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteCart,
          [cartId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, void>>.value(
            _FakeEither_0<_i5.Failure, void>(
          this,
          Invocation.method(
            #deleteCart,
            [cartId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, void>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>> updateCart(
    String? cartId,
    Map<String, dynamic>? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateCart,
          [
            cartId,
            data,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.CartEntity>(
          this,
          Invocation.method(
            #updateCart,
            [
              cartId,
              data,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>> getCartById(
          String? cartId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getCartById,
          [cartId],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.CartEntity>(
          this,
          Invocation.method(
            #getCartById,
            [cartId],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>);

  @override
  _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>> deleteCartItem(
    String? cartId,
    String? itemId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteCartItem,
          [
            cartId,
            itemId,
          ],
        ),
        returnValue: _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>.value(
            _FakeEither_0<_i5.Failure, _i6.CartEntity>(
          this,
          Invocation.method(
            #deleteCartItem,
            [
              cartId,
              itemId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Either<_i5.Failure, _i6.CartEntity>>);
}
