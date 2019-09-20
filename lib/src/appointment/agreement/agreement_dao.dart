import '../core/dao/dao.dart';
import '../core/dao/collection.dart';
import '../core/dao/field.dart';
import '../core/dao/filter.dart';
import 'agreement_constants.dart';

class AgreementDAO extends DAO {
  AgreementDAO()
      : super(new Filter(
            new Collection(
                AGREEMENT_COLLECTION,
                "",
                new List<Field>.from(AGREEMENT_COLLECTION_MODEL.map((field) =>
                    new Field(field.keys.first, field.values.first, "")))),
            null,
            null));
}
