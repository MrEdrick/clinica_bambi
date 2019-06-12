import 'dart:async';
import 'dentist.dart';
import 'dentist_dao.dart';
import 'dentistUI.dart';

import '../dentist_procedure/dentist_procedure.dart';
import '../dentist_procedure/dentist_procedure_service.dart';

import '../dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week.dart';
import '../dentist_quantity_per_shift_by_day_of_week/dentist_quantity_per_shift_by_day_of_week_service.dart';

class DentistService {
  static String _id;
  static Dentist _dentist;
  static Map _dentistListById = new Map();
  static List<Dentist> _list = new List<Dentist>();
  static List<Map> _dentistList = new List<Map>();
  static List<Map> _dentistListWithFilter = new List<Map>();

  String get id => _id;
  set id(String id) => _id = id;

  Dentist get dentist => _dentist;
  set dentist(Dentist dentist) => _dentist = dentist;

  void clearAllDentistList() {
    _list.clear();
    _dentistList.clear();
    _dentistListById.clear();
    _dentistListWithFilter.clear();
  }

  Future<List<Dentist>> getAllDentistAcives() async {
    if ((_dentistList != null) && (_dentistList?.length != 0)) {
      return _list;
    }
  
    clearAllDentistList();
  
    await (_dentistList = await new DentistDAO()
        .getAllDentistFilter({"state": "A"}, {"name": "asc"}));
  
    _dentistList.forEach((dentist) {
      _dentistListById[dentist["documentPath"]] = dentist;
      _list.add(turnMapInDentist(dentist));
    });

    return _list;
  }

  Future<List<DentistUI>> getAllDentistUIAcives() async {
    if ((_dentistList == null) || (_dentistList?.length == 0)) {
      await getAllDentistAcives();
    }

    List<DentistUI> _listDentistUI = new List<DentistUI>();

    for (Dentist _detist in _list) {
      _listDentistUI.add(new DentistUI(_detist.id, _detist.name));
    }

    return _listDentistUI;
  }

  Future<Dentist> getDentistById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return returnEmptyDentist();
    }

    if ((_dentistList == null) || (_dentistList?.length == 0)) {
      await getAllDentistAcives();
    }

    doc = _dentistListById[id];

    if (doc == null) {
      doc = (await new DentistDAO()
              .getAllDentistFilter({'id': id}, {"name": "asc"}))
          .first;
    }

    return turnMapInDentist(doc);
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

    _listDocumentSnapshot.clear();
    _dentistList.forEach((dentist) {
      _listDocumentSnapshot.add(dentist);
    });

    _listDocumentSnapshotTemp.clear();

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["documentPath"].toString() == filter["dentistId"].toString()) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["dentistId"] != null) && (filter["dentistId"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    if ((filter["name"] != null) && (filter["name"] != '')) {
      _listDocumentSnapshot.forEach((doc) {
        if (doc["name"].toString().indexOf(filter["name"]) > -1) {
          _listDocumentSnapshotTemp.add(new Map.from(doc));
        }
      });
    }

    if ((filter["name"] != null) && (filter["name"] != '')) {
      _listDocumentSnapshot.clear();
      ListsApplyFilter();
    }

    _dentistListWithFilter = _listDocumentSnapshot;

    return _dentistListWithFilter;
  }

  List<Map> getDentistListWithFilter() {
    return _dentistListWithFilter;
  }


  Dentist returnEmptyDentist() {
    return new Dentist("", "", false);
  }

  Dentist turnMapInDentist(Map map) {
    return new Dentist(map["documentPath"], map["name"], map["state"] == "A");
  }

  Future<bool> save() async {
    bool saved = true;
    Map<bool, String> result = new Map<bool, String>();

    if (_dentist == null) {
      return saved;
    }

    Map<String, dynamic> datas = {
      "name": _dentist.name,
      "state": _dentist.state ? "A" : "I"
    };

    if (_dentist.id != "") {
      result[await new DentistDAO().update(_dentist.id, datas) == ""] =
          _dentist.id;
    } else {
      result = await new DentistDAO().save(datas);
    }

    DentistProcedureService _dentistProcedureService =
        new DentistProcedureService();

    DentistQuantityPerShiftByDayOfWeekService
        _dentistQuantityPerShiftByDayOfWeekService =
        new DentistQuantityPerShiftByDayOfWeekService();

    _dentistProcedureService.dentistProcedure = null;

    _dentistQuantityPerShiftByDayOfWeekService
        .dentistQuantityPerShiftByDayOfWeek = null;

    for (DentistProcedure dentistProcedure in _dentistProcedureService
        .dentistProcedureListByDentistIdProcedureId.values) {
      _dentistProcedureService.dentistProcedure = dentistProcedure;
      saved = await (_dentistProcedureService.save(result.values.first));
    }

    if (!saved) {
      return saved;
    } else {
      _dentistProcedureService.clearAllDentistProcedureList();
    }

    for (DentistQuantityPerShiftByDayOfWeek dentistQuantityPerShiftByDayOfWeek
        in _dentistQuantityPerShiftByDayOfWeekService
            .dentistQuantityPerShiftByDayOfWeekListByDentistIdDayOfWeekShiftId
            .values) {
      _dentistQuantityPerShiftByDayOfWeekService
              .dentistQuantityPerShiftByDayOfWeek =
          dentistQuantityPerShiftByDayOfWeek;

      saved = await (_dentistQuantityPerShiftByDayOfWeekService.save());
    }

    if (saved) {
      _dentistQuantityPerShiftByDayOfWeekService
          .clearAllDentistQuantityPerShiftByDayOfWeekList();
    }

    return saved;
  }
}
