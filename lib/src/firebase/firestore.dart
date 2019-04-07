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

  Future<bool> addItem(Map<String, dynamic> datas) async {
    try {
      fb.firestore().enableNetwork();
      await this._ref.add(datas);
      return true;
    } catch (e) {
      print("Error ao escrever documento, $e");
      return false;
    } finally {
      fb.firestore().disableNetwork();
    }
  }

  void deleteItem(String id) async {
    try {
      fb.firestore().enableNetwork();
      await this._ref.doc(id).delete();
    } catch (e) {
      print("Erro ao deletar, $e");
    } finally {
      fb.firestore().disableNetwork();
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
