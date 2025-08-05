import 'dart:convert';

import 'package:dreemz/models/image_model.dart';
import 'package:dreemz/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  final favList = [].obs;
  final isExpanded = true.obs;
  final ScrollController myScrollController = ScrollController();
  final StorageService storageService;

  HomePageController({required this.storageService});

  @override
  void onInit() {
    super.onInit();

    loadMyFav();

    myScrollController.addListener(() {
      if (myScrollController.position.userScrollDirection == ScrollDirection.reverse) {
        if (isExpanded.value) isExpanded.value = false;
      } else if (myScrollController.position.userScrollDirection == ScrollDirection.forward) {
        if (!isExpanded.value) isExpanded.value = true;
      }
    });
  }

  void loadMyFav() {
    favList.clear();
    dynamic converted = jsonDecode(storageService.get(StorageKey.favList, "[]"));
    favList.addAll(converted.map((e) => ImageModel.fromJson(e)).toList().cast<ImageModel>());
    favList.refresh();
  }

  @override
  void onClose() {
    super.onClose();
    myScrollController.dispose();
  }

  void removeFromMyFav(int index) {
    favList.removeAt(index);

    //refresh list in local storage also
    storageService.put(StorageKey.favList, jsonEncode(favList));

    favList.refresh();
  }
}
