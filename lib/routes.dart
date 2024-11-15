import 'package:get/get.dart';
import 'package:photo_gallery_final/screens/add_image_screen.dart';
import 'package:photo_gallery_final/screens/home_screen.dart';
import 'package:photo_gallery_final/screens/image_details.dart';

class RoutesClass{
  static String home="/";
  static String addImageScreen="/addImageScreen";
  static String imageDetails="/imageDetails";

  static String getHomeRoute()=>home;
  static String getAddImageScreenRoute()=>addImageScreen;
  static String getImageDetailsRoute()=>imageDetails;

  static List<GetPage> routes =[
    GetPage(name: home, page: ()=> HomeScreen()),
    GetPage(name: addImageScreen, page: ()=> AddImageScreen()),
    GetPage(name: imageDetails, page: ()=> ImageDetails()),

  ];

}