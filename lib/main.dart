import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery_final/routes.dart';

void main() {
  runApp(PhotoGallery());
}

class PhotoGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: RoutesClass.getHomeRoute(),
      getPages: RoutesClass.routes,
    );
  }
}
