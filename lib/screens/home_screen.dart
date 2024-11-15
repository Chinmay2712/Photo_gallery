import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_gallery_final/appwrite_setup/appwrite_provider.dart';
import 'package:photo_gallery_final/constants.dart';
import 'package:photo_gallery_final/routes.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AppWriteProvider provider = AppWriteProvider();
  List<Map<String, dynamic>> uploadedImages = [];
  List<Map<String, dynamic>> foundImages = [];

  @override
  void initState() {
    super.initState();
    _fetchImages();
    foundImages = uploadedImages;
  }

  void runFilter(String enteredKeyword){
    List<Map<String, dynamic>> results = [];
    if(enteredKeyword.isEmpty){
      results = uploadedImages;
    }
    else{
      results = uploadedImages.where((image) {
        final imageName = image['imageName'].toString().toLowerCase();
        return imageName.contains(enteredKeyword.toLowerCase());
      }).toList();
    }

    setState(() {
      foundImages = results;
    });
  }

  Future<void> _fetchImages() async {
    try {
      final response = await provider.databases.listDocuments(
        databaseId: kAppwriteDatabaseID,
        collectionId: kAppwriteCollectionID,
      );

      List<Map<String, dynamic>> images = response.documents.map((doc) {
        return {
          'imageName': doc.data['imageName'],
          'category': doc.data['category'],
          'imageUrl': '$kAppwriteEndpoint/storage/buckets/$kAppwriteBucketID/files/${doc.data['fileID']}/view?project=$kAppwriteProjectID',
          'creationTime': doc.data['creationTime'],
          'updateTime': doc.data['updateTime'],
          'documentId': doc.$id,
          'fileID': doc.data['fileID'],
        };
      }).toList();

      setState(() {
        uploadedImages = images;
      });
    } catch (e) {
      print('Error fetching images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: const Center(
              child: Text(
                'Photo Gallery',
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: Color(0xff7C487B)),
        body: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                onChanged: (value) {
                  runFilter(value);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'Search by Name',
                  suffixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: foundImages.length,
                itemBuilder: (BuildContext context, int index) {
                  final image = foundImages[index];
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        RoutesClass.getImageDetailsRoute(),
                        arguments: {
                          'imageUrl': image['imageUrl'],
                          'imageName': image['imageName'],
                          'category': image['category'],
                          'creationTime': image['creationTime'],
                          'updateTime': image['updateTime'],
                          'documentId': image['documentId'],
                          'fileID': image['fileID']
                        },
                      );
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: image['imageUrl'],
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.toNamed(RoutesClass.getAddImageScreenRoute());
          },
          backgroundColor: Color(0xffEADDFF),
          child: const Icon(
            Icons.add,
            color: Color(0xff7C487B),
          ),
        ),
      ),
    );
  }
}
