// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:dreemz/viewmodels/home_page_controller.dart';
import 'package:dreemz/views/home_page.dart';
import 'package:dreemz/service/storage_service.dart';

class MockStorageService extends Mock implements StorageService {}

class MockHomePageController extends Mock implements HomePageController {}

void main() {
  late HomePageController controller;

  setUp(() {
    final mockStorage = MockStorageService();
    when(() => mockStorage.get(StorageKey.favList, "[]")).thenReturn("[]");

    controller = HomePageController(storageService: mockStorage);
    Get.put(controller);
  });

  testWidgets('HomePage shows AppBar, FAB, and empty text when list is empty', (WidgetTester tester) async {
    controller.favList.clear();

    await tester.pumpWidget(
      GetMaterialApp(
        home: HomePage(),
      ),
    );
    //expects delay to load page with animation, load time etc etc
    await tester.pumpAndSettle();

    expect(find.text("My Favourite Images"), findsOneWidget);

    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text("Add Image"), findsOneWidget);

    expect(find.text("Your favorite list is empty."), findsOneWidget);
  });
}
