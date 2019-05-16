import 'dart:async';
import 'package:firebase/firebase.dart' as fb;
import 'package:firebase/firestore.dart';

class FireStoreApp {
  CollectionReference _ref;

  FireStoreApp(String collection) {
    fb.firestore().enableNetwork();
    this._ref = fb.firestore().collection(collection);
  }


  FireStoreOnLine() {
    fb.firestore().enableNetwork();
  }

  FireStoreOffLine() {
    fb.firestore().disableNetwork();
  }

  CollectionReference get ref => _ref;

  Stream<QuerySnapshot> selectItens(String orderBy) {
    return this._ref.orderBy(orderBy).onSnapshot;
  }

  Future<Map<bool, String>> addItem(Map<String, dynamic> datas) async {
    try {
      fb.firestore().enableNetwork();
      DocumentReference doc = (await this._ref.add(datas));
      return {true : doc.id};
    } catch (e) {
      return {false : "Error ao escrever documento, $e"};
    } finally {
      fb.firestore().disableNetwork();
    }
  }

  Future<bool> deleteItem(String id) async {
    bool error = false;

    try {
      fb.firestore().enableNetwork();
      await this._ref.doc(id).delete();
    } catch (e) {
      print("Erro ao deletar, $e");
      error = true;
    } finally {
      fb.firestore().disableNetwork();
      return !error;
    }
  }
  
  //DocumentSnapshot docSnapshot
  Future<bool> updateItem(String id, Map<String, dynamic> datas) async {
    var values = new Map();//docSnapshot.data();

    void interateMapentry(key, value) {
      values[key] = value;
    }

    datas.forEach(interateMapentry);
    try {
      fb.firestore().enableNetwork();
      await this._ref.doc(id).update(data: values);
      return true;
    } catch (e) {
      print("Erro ao atualizar, $e");
      return false;
    } finally {
      fb.firestore().disableNetwork();
    }
  }
}
