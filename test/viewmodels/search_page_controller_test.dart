import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dreemz/models/image_model.dart';
import 'package:dreemz/service/storage_service.dart';
import 'package:dreemz/viewmodels/search_page_controller.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorageService;
  late SearchPageController controller;

  setUp(() {
    mockStorageService = MockStorageService();

    when(() => mockStorageService.get(StorageKey.favList, "[]")).thenReturn("[]");

    controller = SearchPageController(storageService: mockStorageService);
    controller.onInit();
  });

  test('verify adds image to favourite and updates storage', () {
    final image = ImageModel(id: 1);
    controller.imageList.add(image);

    controller.addToFavourite(0);

    expect(controller.imageList[0].isFav, true);
    expect(controller.savedFav.length, 1);
    expect(controller.savedFav.first.id, 1);

    verify(() => mockStorageService.put(
      StorageKey.favList,
      any(
        that: predicate<String>((json) {
          final decoded = jsonDecode(json) as List;
          return decoded.length == 1 && decoded.first['id'] == 1;
        }),
      ),
    )).called(1);
  });

  test('verify removes image from favourite and updates storage', () {
    final image = ImageModel(id: 1);
    image.isFav = true;
    controller.imageList.add(image);
    controller.savedFav.add(image);

    controller.addToFavourite(0);

    expect(controller.imageList[0].isFav, false);
    expect(controller.savedFav.length, 0);

    verify(() => mockStorageService.put(
      StorageKey.favList,
      any(
        that: predicate<String>((json) {
          final decoded = jsonDecode(json) as List;
          return decoded.isEmpty;
        }),
      ),
    )).called(1);
  });
}
