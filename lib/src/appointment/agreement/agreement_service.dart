import 'dart:async';

import 'agreement.dart';
import 'agreement_dao.dart';
import 'agreementUI.dart';

class AgreementService {
  static String _id;
  static Agreement _agreement;
  static Map _agreementListById = new Map();
  static List<Agreement> _list = new List<Agreement>();
  static List<Map> _agreementList = new List<Map>();
  static List<Map> _agreementListWithFilter = new List<Map>();

  String get id => _id;
  set id(String id) => _id = id;

  Agreement get agreement => _agreement;
  set agreement(Agreement agreement) => _agreement = agreement;

  void clearAllAgreementList() {
    _list.clear();
    _agreementList.clear();
    _agreementListById.clear();
    _agreementListWithFilter.clear();
  }

  Future<List<Agreement>> getAllAgreementAcives() async {
    if ((_agreementList != null) && (_agreementList.length != 0)) {
      return _list;
    }

    clearAllAgreementList();

    await (_agreementList = await new AgreementDAO()
        .getAllAgreementFilter({"state": "A"}, {"description": "asc"}));

    _agreementList.forEach((agreement) {
      _agreementListById[agreement["documentPath"]] = agreement;
      _list.add(turnMapInAgreement(agreement));
    });

    return _list;
  }

  Future<List<AgreementUI>> getAllAgreementUIAcives() async {
    if ((_agreementList == null) || (_agreementList.length == 0)) {
      await getAllAgreementAcives();
    }

    List<AgreementUI> _listAgreementUI = new List<AgreementUI>();

    for (Agreement _agreement in _list) {
      _listAgreementUI
          .add(new AgreementUI(_agreement.id, _agreement.description));
    }

    return _listAgreementUI;
  }

  Future<Agreement> getAgreementById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyAgreement();
    }

    if ((_agreementList == null) || (_agreementList?.length == 0)) {
      await getAllAgreementAcives();
    }

    doc = _agreementListById[id];

    if (doc == null) {
      doc = (await new AgreementDAO()
              .getAllAgreementFilter({'id': id}, {"description": "asc"}))
          .first;
    }

    return turnMapInAgreement(doc);
  }

  List<Map> getAgreementListWithFilterFromList(Map filter) {
    List<Map> _listDocumentSnapshot = new List<Map>();

    List<Map> _listDocumentSnapshotTemp = new List<Map>();

    void ListsApplyFilter() {
      if (_listDocumentSnapshotTemp.length > 0) {
        _listDocumentSnapshotTemp.forEach((doc) {
          _listDocumentSnapshot.add(new Map.from(doc));
        });

        _listDocumentSnapshotTemp.clear();
      }
    }

    _listDocumentSnapshot = _agreementList;

    _listDocumentSnapshotTemp.clear();

    if ((filter["description"] != null) && (filter["description"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["description"].toString().indexOf(filter["description"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["description"] != null) && (filter["description"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    _agreementListWithFilter = _listDocumentSnapshot;

    return _agreementListWithFilter;
  }

  List<Map> getAgreementListWithFilter() {
    return _agreementListWithFilter;
  }

  Agreement returnEmptyAgreement() {
    return new Agreement("", "", false);
  }

  Agreement turnMapInAgreement(Map map) {
    return new Agreement(map["documentPath"], map["description"], map["state"]);
  }
}
