import 'dart:convert';

import 'package:dreemz/viewmodels/home_page_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dreemz/models/image_model.dart';
import 'package:dreemz/service/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

void main() {
  late MockStorageService mockStorageService;
  late HomePageController controller;

  setUp(() {
    mockStorageService = MockStorageService();

    final mockList = [
      ImageModel(id: 1),
      ImageModel(id: 2),
    ];

    when(() => mockStorageService.get(StorageKey.favList, "[]"))
        .thenReturn(jsonEncode(mockList.map((e) => e.toJson()).toList()));

    controller = HomePageController(storageService: mockStorageService);
    controller.onInit();
  });

  test('verify item remove from favourite and update storage', () {
    expect(controller.favList.length, 2);

    controller.removeFromMyFav(0);

    expect(controller.favList.length, 1);
    expect(controller.favList[0].id, 2);

    verify(() => mockStorageService.put(
      StorageKey.favList,
      any(that: predicate<String>((json) {
        final decoded = jsonDecode(json) as List;
        return decoded.length == 1 && decoded[0]['id'] == 2;
      })),
    )).called(1);
  });
}
