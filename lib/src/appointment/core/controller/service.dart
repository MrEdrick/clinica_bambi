import '../dao/dao.dart';
import '../dao/condition.dart';
import '../dao/order_by.dart';

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

  Future<Map> getById(String id) async {
    Map doc;

    if (id.isEmpty) {
      return null;
    }

    if ((_mapList == null) || (_mapList?.length == 0)) {
      await getAllAcives();
    }

    doc = _mapListById[id];

    if (doc == null) {
      _dao.filter.conditionList.clear()
      _dao.filter.conditionList.add(new Condition("id", id, "="));
      _dao.filter.orderBy = new OrderBy("description", "asc");
      doc = (await new _dao.getAllFilter())
          .first;
    }

    return doc;
  }

}
