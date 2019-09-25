import '../dao/dao.dart';
import '../dao/order_by.dart';
import '../dao/condition.dart';
import '../dao/filter.dart';

class Service {
  static String _id;
  static Object _object;

  static Map _mapListById = new Map();
  static List<Map> _mapList = new List<Map>();
  static List<Map> _mapListWithFilter = new List<Map>();

  static DAO _dao;

  void clearAllLists() {
    _mapList.clear();
    _mapListById.clear();
    _mapListWithFilter.clear();
  }

  Map get mapListById => _mapListById;

  List<Map> get mapList => _mapList;
  
  List<Map> get mapListWithFilter => _mapListWithFilter;

  Future<List<Map>> getAllAcives() async {
    if ((_mapList != null) && (_mapList.length != 0)) {
      return _mapList;
    }

    clearAllLists();

    await (_mapList = await _dao.getAllFilter());

    _mapList.forEach((object) {
      _mapListById[object["documentPath"]] = object;
    });

    return _mapList;
  }

  Future<Map> getById(String id, OrderBy orderBy) async {
    Map doc;

    if (id.isEmpty) {
      return null;
    }

    if ((_mapList == null) || (_mapList?.length == 0)) {
      await getAllAcives();
    }

    doc = _mapListById[id];

    if (doc == null) {
      _dao.filter
        ..conditionList.clear()
        ..conditionList.add(new Condition("id", id, "="))
        ..orderBy = orderBy;
      doc = (await _dao.getAllFilter()).first;
    }

    return doc;
  }

  bool _toCompare(String condition, String value, String filterValue) {
    if (condition == "has") {
      return (value.toString().indexOf(filterValue) > -1);
    }

    return false;
  }

  void _applyFilter(List<Map> list, List<Map> listTemp) {
    list.clear();

    if (listTemp.length > 0) {
      listTemp.forEach((doc) {
        list.add(new Map.from(doc));
      });

      listTemp.clear();
    }
  }

  List<Map> getListWithFilter(Filter filter) {
    List<Map> _list = new List<Map>();
    List<Map> _listTemp = new List<Map>();
    _list.clear();
    _listTemp.clear();

    _mapList.forEach((_object) {
      _list.add(_object);
    });

    filter.conditionList.forEach((condition) {
      if ((condition.value != null) && (condition.value != '')) {
        _list.forEach((doc) {
          if (_toCompare(condition.comparation, doc[condition.field].toString(),
              condition.value)) {
            _listTemp.add(new Map.from(doc));
          }
        });

        _applyFilter(_list, _listTemp);
      }
    });

    _mapListWithFilter = _list;

    return _mapListWithFilter;
  }
}
