const String AGREEMENT_COLLECTION = "agreement";
const String AGREEMENT_ID_FIELD = "id";
const String AGREEMENT_DESCRIPTION_FIELD = "description";
const String AGREEMENT_STATE_FIELD = "state";

final AGREEMENT_COLLECTION_MODEL = [
  {
    "description": AGREEMENT_ID_FIELD,
    "fieldType": {
      "type": "PrimaryKey",
      "valueType": "String",
      "isMainField": false
    },
    "title": "Id"
  },
  {
    "description": AGREEMENT_DESCRIPTION_FIELD,
    "fieldType": {"type": "Common", "valueType": "String", "isMainField": true},
    "title": "Convênio"
  },
  {
    "description": AGREEMENT_STATE_FIELD,
    "fieldType": {
      "type": "Common",
      "valueType": "Boolean",
      "isMainField": true
    },
    "title": "Estado"
  }
];
