import '../core/dao/dao.dart';
import '../core/model/collection.dart';
import '../core/model/field.dart';
import '../core/controller/factory/factory_field_type.dart';
import '../core/model/constants.dart';
import '../core/dao/filter.dart';
import 'agreement_constants.dart';

class AgreementDAO extends DAO {
  AgreementDAO()
      : super(new Filter(
            new Collection(
                AGREEMENT_COLLECTION,
                "",
                new List<Field>.from(AGREEMENT_COLLECTION_MODEL.map((field) =>
                    new Field(
                        field[FIELD_MODEL_DESCRIPTION],
                        new FactoryFieldType(field[FIELD_MODEL_FIELD_TYPE])
                            .returnFieldType(),
                        "",
                        field[FIELD_MODEL_TITLE]))),
                "Convênio",
                "credit_card"),
            null,
            null));
}
