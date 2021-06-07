import 'package:get_it/get_it.dart';
import 'di.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(Di());
}