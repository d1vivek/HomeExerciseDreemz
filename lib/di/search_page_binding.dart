import 'package:dreemz/viewmodels/search_page_controller.dart';
import 'package:get/get.dart';

class SearchPageBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [Bind.lazyPut<SearchPageController>(() => SearchPageController(storageService: Get.find()))];
  }
}
