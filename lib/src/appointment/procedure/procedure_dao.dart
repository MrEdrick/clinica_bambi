import '../core/dao/dao.dart';
import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/model/constants.dart';
import '../core/dao/filter.dart';
import 'procedure_constants.dart';

class ProcedureDAO extends DAO {
   ProcedureDAO()
      : super(new Filter(
            new Collection(
                PROCEDURE_COLLECTION,
                "",
                new List<Field>.from(PROCEDURE_COLLECTION_MODEL.map((field) =>
                    new Field(field[INDEX_DESCRIPTION], field[INDEX_TYPE], "",
                        field[INDEX_TITLE]))),
                "Convênio",
                "credit_card"),
            null,
            null));

}