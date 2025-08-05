import 'package:dreemz/core/routes.dart';
import 'package:dreemz/core/themes/colors.dart';
import 'package:dreemz/viewmodels/home_page_controller.dart';
import 'package:dreemz/views/image_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetWidget<HomePageController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Favourite Images")),
      floatingActionButton: Obx(() {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 450),
          child: FloatingActionButton.extended(
            isExtended: controller.isExpanded.value,
            icon: Icon(Icons.add),
            backgroundColor: AppColors.colorPrimary,
            onPressed: () async {
              await Get.toNamed(Routes.searchPage);
              controller.loadMyFav();
            },
            label: const Text("Add Image"),
          ),
        );
      }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(() {
            if (controller.favList.isEmpty) {
              return Center(child: Text("Your favorite list is empty."));
            }

            return GridView.builder(
              controller: controller.myScrollController,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                childAspectRatio: 0.8,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                maxCrossAxisExtent: (Get.width / 2),
              ),
              itemBuilder: (context, index) {
                return ImageTile(controller.favList[index], () {
                  showRemoveAlert(index);
                }, shouldShowFav: false);
              },
              itemCount: controller.favList.length,
            );
          }),
        ),
      ),
    );
  }

  void showRemoveAlert(int index) {
    Get.dialog(
      AlertDialog(
        title: Text("Remove item ?"),
        content: Text("Are you sure you want to remote this image from your favourite list?"),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.closeAllDialogs();
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.colorSecondary, foregroundColor: Colors.black),
            child: Text("NO"),
          ),
          ElevatedButton(
            onPressed: () {
              Get.closeAllDialogs();
              controller.removeFromMyFav(index);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.colorPrimary, foregroundColor: Colors.black),
            child: Text("YES"),
          ),
        ],
      ),
    );
  }
}
