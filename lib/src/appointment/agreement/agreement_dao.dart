//import 'dart:async';

import 'agreement_constants.dart';
//import '../../firebase/firestore.dart';
import '../base/dao.dart';

class AgreementDAO extends DAO {
  AgreementDAO();

  @override
  Future<List<Map>> getAllFilter(
          Map filter, Map orderBy, List comparisons) async =>
      super.getAllFilter(AGREEMENT_COLLECTION, filter, orderBy, comparisons);

  /*Future<List<Map>> getAllAgreementFilter(Map filter, Map orderBy) async {
    List<Map> _list = new List<Map>();
    FireStoreApp fireStoreApp =
        new FireStorSeApp(AGREEMENT_COLLECTION);

    await (await fireStoreApp.ref
            .where(filter.keys.first, '==', filter.values.first)
            .orderBy(orderBy.keys.first, orderBy.values.first)
            .get())
        .docs
        .forEach((doc) {
      Map map = new Map.from(doc.data());
      map['documentPath'] = doc.id;
      _list.add(map);
    });

    fireStoreApp.FireStoreOffLine();

    return _list;
  }*/
}
