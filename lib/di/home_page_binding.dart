import 'package:dreemz/viewmodels/home_page_controller.dart';
import 'package:get/get.dart';

class HomePageBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<HomePageController>(() => HomePageController(
        storageService: Get.find()
      )),
    ];
  }
}