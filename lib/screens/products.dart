import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> addProductToFirestore(
  CollectionReference productsCollection,
  String productId,
  String productName,
  double price,
  String description,
  String gender,
  String category,
  List<String> images,
  int smallQuantity,
  int mediumQuantity,
  int largeQuantity,
) async {
  try {
    await productsCollection.add({
      'productId': productId,
      'productName': productName,
      'price': price,
      'description': description,
      'gender': gender,
      'category': category,
      'images': images,
      'smallQuantity': smallQuantity,
      'mediumQuantity': mediumQuantity,
      'largeQuantity': largeQuantity,
    });
    // Success! The product has been added to Firestore.
  } catch (e) {
    // Handle any errors that occur during the process.
  }
}
