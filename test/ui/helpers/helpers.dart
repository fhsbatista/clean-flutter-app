import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget makePage({
  required String path,
  required Widget Function() page,
  bool isLogin = false,
}) {
  final pages = [
    GetPage(
      name: path,
      page: page,
    ),
    GetPage(
      name: '/fake_route',
      page: () => Scaffold(appBar: AppBar(), body: Text('fake page')),
    ),
    if (!isLogin)
      GetPage(
        name: '/login',
        page: () => Scaffold(body: Text('login page')),
      ),
  ];

  return GetMaterialApp(
    initialRoute: path,
    navigatorObservers: [Get.put<RouteObserver>(RouteObserver<PageRoute>())],
    getPages: pages,
  );
}
