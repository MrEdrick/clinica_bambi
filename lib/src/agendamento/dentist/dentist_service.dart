import 'dart:async';
import 'dentist.dart';
import 'dentist_dao.dart';
import 'dentistUI.dart';

class DentistService {
  static List<Dentist> _list;
  static Dentist _dentist;
  static List<Map> _dentistList;
  static List<Map> _dentistListWithFilter;

  void clearAllDentistList() {
    _list.clear();
    _dentistList.clear();
    _dentistListWithFilter.clear();
  }

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  Future<List<Dentist>> getAllDentistAcives() async {
    if ((_dentistList != null) && (_dentistList.length != 0)) {
      return _list;
    }

    clearAllDentistList();

    await (_dentistList = await new DentistDAO()
        .getAllDentistFilter({"state": "A"}, {"name": "asc"}));

    _dentistList.forEach((dentist) {
      _list.add(turnMapInConsulta(dentist));
    });

    return _list;
  }

  Future<List<DentistUI>> getAllDentistUIAcives() async {
    if (_list == null) {
      await getAllDentistAcives();
    }

    List<DentistUI> _listDentistUI = new List<DentistUI>();

    for (Dentist _detist in _list) {
      _listDentistUI.add(new DentistUI(_detist.id, _detist.name));
    }

    return _listDentistUI;
  }

  Future<Dentist> getDentistById(String id) async {
    if (_list == null) {
      await getAllDentistAcives();
    }

    for (var i = 0; i < _list.length; i++) {
      if (_list[i].id == id) {
        return _list[i];
      }
    }
    ;

    return null;
  }

  List<Map> getDentistListWithFilterFromList(Map filter) {
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

    _listDocumentSnapshot = _dentistList;

    _listDocumentSnapshotTemp.clear();

    if ((filter["name"] != null) && (filter["name"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["name"].toString().indexOf(filter["name"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["name"] != null) && (filter["name"] != '')) {
      _listDocumentSnapshot.clear();
    }

    ListsApplyFilter();

    _dentistListWithFilter = _listDocumentSnapshot;

    return _dentistListWithFilter;
  }

  List<Map> getDentistListWithFilter() {
    return _dentistListWithFilter;
  }

  Dentist turnMapInConsulta(Map map) {
    return new Dentist(map["documentPath"], map["name"], map["state"]);
  }
}
