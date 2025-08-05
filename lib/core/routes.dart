
import 'package:dreemz/di/home_page_binding.dart';
import 'package:dreemz/di/search_page_binding.dart';
import 'package:dreemz/views/home_page.dart';
import 'package:dreemz/views/search_page.dart';
import 'package:dreemz/views/unknown_page.dart';
import 'package:get/get.dart';

abstract class Routes {
  Routes._();

  static const unknownPage = "/unknownPage";
  static const homePage = "/homePage";
  static const searchPage = "/searchPage";

  static final unknownWidget = GetPage(
    name: Routes.unknownPage,
    page: () => const UnknownPage(),
  );

  static final routePage = [
    unknownWidget,
    GetPage(
      name: homePage,
      page: () => const HomePage(),
      binding: HomePageBinding(),
    ),
    GetPage(
      name: searchPage,
      page: () => SearchPage(),
      binding: SearchPageBinding(),
    ),
  ];
}
