import '../core/dao/dao.dart';
import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/model/constants.dart';
import '../core/dao/filter.dart';
import 'requirement_constants.dart';

class RequirementDAO extends DAO {
   RequirementDAO()
      : super(new Filter(
            new Collection(
                REQUIREMENT_COLLECTION,
                "",
                new List<Field>.from(REQUIREMENT_COLLECTION_MODEL.map((field) =>
                    new Field(field[INDEX_DESCRIPTION], field[INDEX_TYPE], "",
                        field[INDEX_TITLE]))),
                "Convênio",
                "credit_card"),
            null,
            null));

}
