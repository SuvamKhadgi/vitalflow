// Mocks generated by Mockito 5.4.5 from annotations
// in vitalflow/test/features/home/presentation/view_model/bloc/dashboard_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:dartz/dartz.dart' as _i3;
import 'package:mockito/mockito.dart' as _i1;
import 'package:vitalflow/core/error/failure.dart' as _i6;
import 'package:vitalflow/features/home/domain/entity/item_entity.dart' as _i7;
import 'package:vitalflow/features/home/domain/repository/item_repository.dart'
    as _i2;
import 'package:vitalflow/features/home/domain/use_case/get_items_usecase.dart'
    as _i4;

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

class _FakeIItemRepository_0 extends _i1.SmartFake
    implements _i2.IItemRepository {
  _FakeIItemRepository_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeEither_1<L, R> extends _i1.SmartFake implements _i3.Either<L, R> {
  _FakeEither_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetItemsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetItemsUseCase extends _i1.Mock implements _i4.GetItemsUseCase {
  MockGetItemsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.IItemRepository get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeIItemRepository_0(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i2.IItemRepository);

  @override
  _i5.Future<_i3.Either<_i6.Failure, List<_i7.ItemEntity>>> call() =>
      (super.noSuchMethod(
        Invocation.method(
          #call,
          [],
        ),
        returnValue:
            _i5.Future<_i3.Either<_i6.Failure, List<_i7.ItemEntity>>>.value(
                _FakeEither_1<_i6.Failure, List<_i7.ItemEntity>>(
          this,
          Invocation.method(
            #call,
            [],
          ),
        )),
      ) as _i5.Future<_i3.Either<_i6.Failure, List<_i7.ItemEntity>>>);
}
