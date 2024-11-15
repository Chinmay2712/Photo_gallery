import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:photo_gallery_final/constants.dart';

class AppWriteProvider {
  Client client = Client();
  late Databases databases;
  late Storage storage;

  AppWriteProvider() {
    client
        .setEndpoint(kAppwriteEndpoint) // Your Appwrite endpoint
        .setProject(kAppwriteProjectID) // Your project ID
        .setSelfSigned(status: true);

    databases = Databases(client);
    storage = Storage(client);
  }

  Future<void> deleteImage(String documentId, String fileId) async {
    try {
      await storage.deleteFile(
        bucketId: kAppwriteBucketID,
        fileId: fileId,
      );

      await databases.deleteDocument(
        databaseId: kAppwriteDatabaseID,
        collectionId: kAppwriteCollectionID,
        documentId: documentId,
      );
    } catch (e) {
      print('Error deleting image: $e');
    }
  }
}

