import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dreemz/core/extension.dart';
import 'package:dreemz/models/image_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImageTile extends StatelessWidget {
  const ImageTile(this.myImage, this.onTap, {super.key, this.shouldShowFav = true});

  final ImageModel myImage;
  final Function onTap;
  final bool shouldShowFav;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade100)),
        padding: EdgeInsets.all(1),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: (Get.width / 2) - 12 - 12,
                  // child: Image.network(myImage.largeImageURL ?? "", fit: BoxFit.cover),
                  child: CachedNetworkImage(
                    imageUrl: myImage.largeImageURL ?? "",
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                  ),
                ),
                8.height,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    myImage.user ?? "N/A",
                    style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                ),
                Text(formatFileSize(myImage.imageSize), style: TextStyle(fontStyle: FontStyle.italic)),
              ],
            ),
            if (shouldShowFav && myImage.isFav)
              Container(
                color: Color(0x70000000),
                child: Center(child: Icon(Icons.check, color: Colors.white, size: 44)),
              ),
          ],
        ),
      ),
    );
  }

  String formatFileSize(int? bytes) {
    if (bytes == null) return "0";
    const suffixes = ["B", "K", "M", "GB", "TB"];
    if (bytes == 0) return '0${suffixes[0]}';
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(2)) + suffixes[i];
  }
}
