
import 'package:get_it/get_it.dart';
import 'package:sellerapp/model/db/brand.dart';
import 'package:sellerapp/model/db/category.dart';
import 'package:sellerapp/model/db/product.dart';

GetIt sl = GetIt.instance;

void serviceLocator() async {
  sl.registerFactory<BrandService>(() => BrandService());
  sl.registerFactory<CategoryService>(() => CategoryService());
  sl.registerFactory<ProductService>(() => ProductService());
}
