import 'dart:convert';

import 'package:dreemz/core/logg.dart';
import 'package:dreemz/models/image_model.dart';
import 'package:dreemz/models/response_status.dart';
import 'package:dreemz/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchPageController extends GetxController {
  final responseStatus = ResponseStatus.none.obs;
  final imageList = <ImageModel>[].obs;
  final savedFav = <ImageModel>[];
  final isLoadingMore = false.obs;
  int page = 1;
  final int perPage = 20;
  final StorageService storageService;
  final ScrollController scrollController = ScrollController();
  final searchTextController = TextEditingController();

  SearchPageController({required this.storageService});

  @override
  void onInit() {
    super.onInit();

    dynamic converted = jsonDecode(storageService.get(StorageKey.favList, "[]"));
    savedFav.addAll(converted.map((e) => ImageModel.fromJson(e)).toList().cast<ImageModel>());

    scrollController.addListener(() {
      if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 200) {
        searchNextPage(searchTextController.text);
      }
    });
  }

  void addToFavourite(int index) {
    imageList[index].isFav = !imageList[index].isFav;
    if (imageList[index].isFav) {
      savedFav.add(imageList[index]);
    } else {
      savedFav.removeWhere((element) => element.id == imageList[index].id);
    }

    storageService.put(StorageKey.favList, jsonEncode(savedFav));

    imageList.refresh();
  }

  bool checkIfFav(ImageModel image) {
    return savedFav.firstWhereOrNull((element) {
          return element.id == image.id;
        }) !=
        null;
  }

  List<ImageModel> getSelectedImages() {
    return imageList.where((element) => element.isFav).toList();
  }

  void searchNextPage(String query) {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;

    searchImageTask(query);
  }

  void searchImageTask(String query) async {
    if (page == 1) {
      responseStatus.value = ResponseStatus.loading;
    }

    final url = Uri.https('pixabay.com', '/api/', {
      'key': '51618299-05420ae36bd773c6f55539bb7',
      'q': Uri.encodeQueryComponent(query),
      "per_page": perPage.toString(),
      "page": page.toString(),
    });
    Logg.printLog("URL >>> $url");
    final response = await http.get(url);
    Logg.printLog("RESPONSE FOR >>> ${response.statusCode} \n$url\n${response.body}");

    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      final hits = decodedResponse['hits'];
      if (hits != null && hits is List) {
        if (page == 1) {
          imageList.clear();
        }
        imageList.addAll(
          hits
              .map((e) {
                final rImage = ImageModel.fromJson(e);
                rImage.isFav = checkIfFav(rImage);
                return rImage;
              })
              .toList()
              .cast<ImageModel>(),
        );
        page++;
        if (isLoadingMore.value) {
          isLoadingMore.value = false;
        }
        responseStatus.value = ResponseStatus.success;
      } else {
        responseStatus.value = ResponseStatus.error;
      }
    } else {
      responseStatus.value = ResponseStatus.error;
    }

    imageList.refresh();
  }
}
