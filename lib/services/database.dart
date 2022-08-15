import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:me_medical_app/models/user.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference itemCollection =
      FirebaseFirestore.instance.collection('items');

  final CollectionReference patientCollection =
      FirebaseFirestore.instance.collection('patients');

  final CollectionReference checkUpCollection =
      FirebaseFirestore.instance.collection('checkup');

  final CollectionReference stockCollection =
      FirebaseFirestore.instance.collection('stocks');

  Future updateUserData(String name, String phone, String email,
      String password, String location) async {
    return await userCollection.doc(uid).set({
      'Name': name,
      'Phone': phone,
      'Email': email,
      'Password': password,
      'Clinic Location': location,
      'User ID': uid
    });
  }

  //update item
  Future updateItemInventory(
      String itemName, double buyPrice, double sellPrice, int stock) async {
    return await itemCollection.doc(uid).collection('itemInfo').add({
      'Item Name': itemName,
      'Buy Price': buyPrice,
      'Sell Price': sellPrice,
      'In Stock': stock,
      'User ID': uid,
    });
  }

  //update user's patient list
  Future updatePatient(String patientName, String ic, String bod, String gender,
      String contactNumber, String address) async {
    return await patientCollection
        .doc(uid)
        .collection('patientInfo')
        .doc(ic)
        .set({
      'Patient Name': patientName,
      'IC': ic,
      'BOD': bod,
      'Gender': gender,
      'ContactNumber': contactNumber,
      'address': address,
    });
  }

  Future updateCheckUpList(String patientName, String ic, String date,
      List<String> medicine, String description) async {
    return await checkUpCollection.doc(uid).collection('checkUpInfo').add({
      'Patient Name': patientName,
      'IC': ic,
      'Date': date,
      'Medications': medicine,
      'Description': description,
    });
  }

  Future updatePatientCheckUpList(String patientName, String ic, String date,
      List<String> medicine, String description) async {
    return await patientCollection
        .doc(uid)
        .collection('patientInfo')
        .doc(ic)
        .collection('patientCheckUpInfo')
        .add({
      'Patient Name': patientName,
      'IC': ic,
      'Date': date,
      'Medications': medicine,
      'Description': description,
    });
  }

  // Decrement medicine stock after check up
  Future updateStockAfterCheckUp(String? docID, int decrementStock) async {
    return await itemCollection
        .doc(uid)
        .collection('itemInfo')
        .doc(docID)
        .update({"In Stock": decrementStock});
  }

  //Add stock based on add stock page
  Future updateStock(String? docID, int incrementStock) async {
    return await itemCollection
        .doc(uid)
        .collection('itemInfo')
        .doc(docID)
        .update({"In Stock": FieldValue.increment(incrementStock)});
  }

  //update profile
  Future updateProfile(String name, String phone, String location) async {
    return await userCollection
        .doc(uid)
        .update({'Name': name, 'Phone': phone, 'Clinic Location': location});
  }

  Future updateItemPurchase(
      String itemID, String date, String qty, String totalPrice) async {
    return await itemCollection
        .doc(uid)
        .collection('itemInfo')
        .doc(itemID)
        .collection('itemPurchaseInfo')
        .add({'Date': date, 'Quantity': qty, 'Price': totalPrice});
  }

  //update item information
  Future updateItemInformation(String docID, String itemName, double buyPrice,
      double sellPrice, int stock) async {
    return await itemCollection
        .doc(uid)
        .collection('itemInfo')
        .doc(docID)
        .update({
      'Item Name': itemName,
      'Buy Price': buyPrice,
      'Sell Price': sellPrice,
      'In Stock': stock,
    });
  }

  //User data from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['Name'],
      phone: snapshot['Phone'],
      email: snapshot['Email'],
      location: snapshot['Location'],
      password: snapshot['Password'],
    );
  }

  //delete item
  Future deleteItem(String itemID) async {
    return await itemCollection
        .doc(uid)
        .collection('itemInfo')
        .doc(itemID)
        .delete();
  }

  //delete item
  Future deletePatient(String patientID) async {
    await patientCollection
        .doc(uid)
        .collection('patientInfo')
        .doc(patientID)
        .delete();

    var snapshot = await checkUpCollection
        .doc(uid)
        .collection('checkUpInfo')
        .where('IC', isEqualTo: patientID)
        .get();

    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  //Change user language
  Future changeLanguage(String language) async {
    return await userCollection.doc(uid).update({
      'language': language,
    });
  }

  //get user data
  Stream<UserData> get userData {
    return userCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
