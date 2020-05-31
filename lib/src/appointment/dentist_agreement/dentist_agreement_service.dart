import 'dentist_agreement.dart';
import 'dentist_agreement_dao.dart';

class DentistAgreementService {
  static DentistAgreement _dentistAgreement;
  static List<DentistAgreement> _list = new List<DentistAgreement>();
  static Map<String, DentistAgreement>
      _dentistAgreementListByDentistIdAgreementId = new Map();
  static List<Map> _dentistAgreementList = new List<Map>();
  static Map<String, DentistAgreement> _dentistAgreementListById = new Map();
  static List<Map> _dentistAgreementListWithFilter = new List<Map>();

  DentistAgreement get dentistAgreement => _dentistAgreement;
  set dentistAgreement(DentistAgreement dentistAgreement) =>
      _dentistAgreement = dentistAgreement;

  Map get dentistAgreementListByDentistIdAgreementId =>
      _dentistAgreementListByDentistIdAgreementId;

  void clearAllDentistAgreementList() {
    _list.clear();
    _dentistAgreementList.clear();
    _dentistAgreementListById.clear();
    _dentistAgreementListWithFilter.clear();
    _dentistAgreementListByDentistIdAgreementId.clear();
  }

  Future<List<DentistAgreement>> getAllDentistAgreementAcives() async {
    if ((_dentistAgreementList != null) &&
        (_dentistAgreementList?.length != 0)) {
      return _list;
    }

    clearAllDentistAgreementList();

    await (_dentistAgreementList = await (new DentistAgreementDAO()
        .getAllDentistAgreementFilter({"isReal": "Y"}, ["=="])));

    _dentistAgreementList.forEach((dentistAgreement) {
      _dentistAgreementListById[dentistAgreement["documentPath"]] =
          turnMapInDentistAgreement(dentistAgreement);

      _dentistAgreementListByDentistIdAgreementId[
              dentistAgreement["dentistId"] + dentistAgreement["agreementId"]] =
          turnMapInDentistAgreement(dentistAgreement);

      _list.add(turnMapInDentistAgreement(dentistAgreement));
    });

    return _list;
  }

  Future<DentistAgreement> getOneDentistAgreementByFilterFromList(
      Map filter) async {
    Map doc;
    List result;

    result = getDentistAgreementListWithFilterFromList(filter);

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInDentistAgreement(doc);
  }

  Future<DentistAgreement> getOneDentistAgreementByFilterFromDataBase(
      Map filter) async {
    Map doc;
    List result;

    result = (await new DentistAgreementDAO()
        .getAllDentistAgreementFilter(filter, ["=="]));

    if (result.length > 0) {
      doc = result?.first;
    } else {
      doc = null;
    }

    return turnMapInDentistAgreement(doc);
  }

  List<Map> getDentistAgreementListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot.clear();
    _dentistAgreementList.forEach((dentistAgreement) {
      _listDocumentSnapshot.add(dentistAgreement);
    });

    _listDocumentSnapshotTemp.clear();

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["dentistId"].toString() == filter["dentistId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    if ((filter["agreementId"] != null) && (filter["agreementId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["agreementId"].toString() == filter["agreementId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["agreementId"] != null) && (filter["agreementId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _dentistAgreementListWithFilter = _listDocumentSnapshot;

    return _dentistAgreementListWithFilter;
  }

  Future<List<String>> returnDentistIdListByAgreementId(
      String procedureId) async {
    if (_dentistAgreementList.isEmpty) {
      await getAllDentistAgreementAcives();
    }

    List<String> listId = new List<String>();
    listId.clear();
    getDentistAgreementListWithFilterFromList({"agreementId": procedureId})
        .forEach((map) {
      if (!listId.contains(map["dentistId"])) {
        listId.add(map["dentistId"]);
      }
    });

    return listId;
  }

  DentistAgreement turnMapInDentistAgreement(Map map) {
    if (map == null) {
      return null;
    }
    return new DentistAgreement(
        map["documentPath"], map["dentistId"], map["agreementId"]);
  }

  Future<bool> save(String dentistId) async {
    bool saved = false;

    if (_dentistAgreement == null) {
      return saved;
    }

    saved = true;

    Map datas = {
      "dentistId": _dentistAgreement.dentistId,
      "agreementId": _dentistAgreement.agreementId,
      "isReal": "Y"
    };

    Map<bool, String> result = new Map<bool, String>();

    if (_dentistAgreement.id != "") {
      if ((_dentistAgreement.dentistId == "") ||
          (_dentistAgreement.agreementId == "")) {
        result[await new DentistAgreementDAO().delete(_dentistAgreement.id) ==
            ""] = _dentistAgreement.id;
      } else {
        result[await new DentistAgreementDAO()
                .update(_dentistAgreement.id, datas) ==
            ""] = _dentistAgreement.id;
      }
    } else {
      if ((_dentistAgreement.dentistId != "") &&
          (_dentistAgreement.agreementId != "")) {
        result = await new DentistAgreementDAO().save(datas);
      }
    }

    return saved = result.keys.first;
  }
}
