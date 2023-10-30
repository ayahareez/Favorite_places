import 'package:cloud_firestore/cloud_firestore.dart';

abstract class RemoteDbHelper {
  Future<void> add(String collectionName, Map<String, dynamic> data);
  Future<void> update(
      String collectionName, String docId, Map<String, dynamic> data);
  Future<void> delete(String collectionName, String docId);
  Future<List> get(String collectionName, Function dTOConverter);
}

class RemoteDbHelperImpl extends RemoteDbHelper {
  @override
  Future<void> add(String collectionName, Map<String, dynamic> data) =>
      FirebaseFirestore.instance.collection(collectionName).add(data);

  @override
  Future<void> delete(String collectionName, String docId) =>
      FirebaseFirestore.instance.collection(collectionName).doc(docId).delete();

  @override
  Future<List> get(String collectionName, Function dTOConverter) async {
    final snapshot =
        await FirebaseFirestore.instance.collection(collectionName).get();
    return snapshot.docs.map((e) => dTOConverter(e)).toList();
  }

  @override
  Future<void> update(
          String collectionName, String docId, Map<String, dynamic> data) =>
      FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId)
          .update(data);
}