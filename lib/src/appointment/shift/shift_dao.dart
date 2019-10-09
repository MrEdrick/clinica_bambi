import '../core/dao/dao.dart';
import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/model/constants.dart';
import '../core/dao/filter.dart';
import 'shift_constants.dart';


class ShiftDAO extends DAO {
  ShiftDAO()
      : super(new Filter(
            new Collection(
                SHIFT_COLLECTION,
                "",
                new List<Field>.from(SHIFT_COLLECTION_MODEL.map((field) =>
                    new Field(field[INDEX_DESCRIPTION], field[INDEX_TYPE], "",
                        field[INDEX_TITLE]))),
                "access_time",
                "credit_card"),
            null,
            null));
}
