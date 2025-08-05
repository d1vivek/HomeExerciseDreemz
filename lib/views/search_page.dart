import 'package:dreemz/core/extension.dart';
import 'package:dreemz/core/themes/colors.dart';
import 'package:dreemz/models/response_status.dart';
import 'package:dreemz/viewmodels/search_page_controller.dart';
import 'package:dreemz/views/image_tile.dart';
import 'package:dreemz/views/unknown_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends GetWidget<SearchPageController> {
  SearchPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add new images")),
      //  lets for now show pagination loading indicator as bottomNav
      bottomNavigationBar: controller.isLoadingMore.value
          ? Container(color: AppColors.colorPrimary.withValues(alpha: 0.7), child: CircularProgressIndicator())
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            children: [
              12.height,
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchTextController,
                      decoration: InputDecoration(
                        hint: Text("Search images ..."),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.colorPrimary, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  12.width,
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.colorPrimary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      minimumSize: Size(52, 52),
                    ),
                    icon: Icon(Icons.search),
                    onPressed: () {
                      controller.searchImageTask(controller.searchTextController.text);
                    },
                  ),
                ],
              ),
              12.height,
              Expanded(
                child: Obx(() {
                  switch (controller.responseStatus.value) {
                    case ResponseStatus.loading:
                      return Center(child: CircularProgressIndicator());
                    case ResponseStatus.success:
                      return GridView.builder(
                        controller: controller.scrollController,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          childAspectRatio: 0.8,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          maxCrossAxisExtent: (Get.width / 2),
                        ),
                        itemBuilder: (context, index) {
                          return ImageTile(controller.imageList[index], () {
                            controller.addToFavourite(index);
                          });
                        },
                        itemCount: controller.imageList.length,
                      );
                    case ResponseStatus.error:
                      return UnknownPage(error: "Error loading images. Please check your internet connection and try again later.");
                    case ResponseStatus.none:
                      return UnknownPage(error: "Type keywords to search image");
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
