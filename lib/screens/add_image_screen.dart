import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_gallery_final/appwrite_setup/appwrite_provider.dart';
import 'package:photo_gallery_final/constants.dart';
import 'dart:io';

class AddImageScreen extends StatefulWidget {
  @override
  State<AddImageScreen> createState() => _AddImageScreenState();
}

class _AddImageScreenState extends State<AddImageScreen> {
  AppWriteProvider provider = AppWriteProvider();
  final List<String> categories = [
    'Nature',
    'People',
    'Urban',
  ];
  String selectedCategory = 'Nature';
  late String imageName;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      // Handle any errors
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff7C487B),
        title: const Center(
          child: Padding(
            padding: EdgeInsets.only(right: 50),
            child: Text(
              'Add Image',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: Colors.grey[300],
                    ),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : const Icon(
                            Icons.image,
                            size: 150,
                          ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 100, right: 100),
                child: ElevatedButton(
                  onPressed: () {
                    _pickImage(ImageSource.gallery);
                  },
                  child: const Center(
                    child: Text(
                      'Upload Photo',
                      style: TextStyle(
                        color: Color(0xff7C487B),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18.0),
                child: TextFormField(
                  onChanged: (String newValue) {
                    imageName = newValue;
                    print(imageName);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    hintText: 'Enter Image Name',
                    hintStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButton<String>(
                value: selectedCategory,
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue!;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 50, right: 50),
                child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll<Color>(Color(0xff7C487B))),
                  onPressed: () {
                    _uploadImage();
                  },
                  child: const Center(
                    child: Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _uploadImage() async {
    if (selectedImage != null && imageName.isNotEmpty) {
      try {
        final storageResponse = await provider.storage.createFile(
          bucketId: kAppwriteBucketID,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: selectedImage!.path),
        );

        final String creationTime = DateTime.now().toIso8601String();
        final String updateTime = creationTime;

        await provider.databases.createDocument(
          databaseId: kAppwriteDatabaseID,
          collectionId: kAppwriteCollectionID,
          documentId: ID.unique(),
          data: {
            'imageName': imageName,
            'category': selectedCategory,
            'fileID': storageResponse.$id,
            'creationTime': creationTime,
            'updateTime': updateTime,
          },
        );
        Navigator.pop(context);
      } catch (e) {
        print('Error uploading image: $e');
      }
    } else {
      print('Please select an image and enter a name');
    }
  }
}
