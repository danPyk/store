// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:http/http.dart' as _i4;
import 'package:injectable/injectable.dart' as _i2;

import 'controllers/auth_controller.dart' as _i10;
import 'services/auth_service.dart' as _i3;
import 'services/cart_service.dart' as _i5;
import 'services/category_service.dart' as _i6;
import 'services/order_service.dart' as _i7;
import 'services/paypal_service.dart' as _i8;
import 'services/product_service.dart'
    as _i9; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
_i1.GetIt $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  gh.singleton<_i3.AuthService>(
    _i3.AuthService(httpClient: get<_i4.Client>()),
    dispose: (i) => i.dispose(),
  );
  gh.factory<_i5.CartService>(() => _i5.CartService());
  gh.factory<_i6.CategoryService>(
      () => _i6.CategoryService(httpClient: get<_i4.Client>()));
  gh.factory<_i7.OrderService>(
      () => _i7.OrderService(httpClient: get<_i4.Client>()));
  gh.factory<_i8.PayPalService>(() => _i8.PayPalService());
  gh.factory<_i9.ProductService>(() => _i9.ProductService());
  gh.factory<_i10.AuthController>(
      () => _i10.AuthController(get<_i3.AuthService>()));
  return get;
}
