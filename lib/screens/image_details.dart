import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery_final/constants.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:photo_gallery_final/appwrite_setup/appwrite_provider.dart';

class ImageDetails extends StatelessWidget {
  AppWriteProvider provider = AppWriteProvider();
  final Map<String, dynamic> imageData = Get.arguments;

  String formatDateTime(String isoString) {
    DateTime dateTime = DateTime.parse(isoString);
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);
    String formattedTime = DateFormat('hh:mm a').format(dateTime);

    return '$formattedDate at $formattedTime';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7C487B),
        title: const Center(
          child: Text(
            'Image Details',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: (){},
            icon: const Icon(Icons.edit),
            color: Colors.white,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            color: Colors.white,
            onPressed: () async {
              await provider.deleteImage(
                  imageData['documentId'], imageData['fileID']);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.grey[300],
              ),
              child: CachedNetworkImage(
                imageUrl: imageData['imageUrl'],
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(
                'Name: ${imageData['imageName']}',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(
                'Category: ${imageData['category']}',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(
                'Create Time: ${formatDateTime(imageData['creationTime'])}',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: Text(
                'Update Time: ${formatDateTime(imageData['updateTime'])}',
                style: const TextStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
