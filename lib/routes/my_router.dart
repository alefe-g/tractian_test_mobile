import 'package:tractian_test_mobile/pages/assets_page.dart';
import 'package:tractian_test_mobile/pages/home_page.dart';

class MyRouter {
  static const home = '/home';
  static const assets = '/assets';

  static final routes = {
    home: (context) => const HomePage(),
    assets: (context) => const AssetsPage(),
  };
}
