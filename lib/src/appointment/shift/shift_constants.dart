const String SHIFT_COLLECTION = 'shift';
const String SHIFT_ID_FIELD = "id";
const String SHIFT_DESCRIPTION_FIELD = "description";
const String SHIFT_OBSERVATION_FIELD = "observation";
const String SHIFT_START_TIME_FIELD = "startTime";
final SHIFT_STATE_FIELD = "state";

final SHIFT_COLLECTION_MODEL = [
  [
    SHIFT_ID_FIELD,
    ["String", true, false, false, []],
    "Id"
  ],
  [
    SHIFT_DESCRIPTION_FIELD,
    ["String", false, false, true, []],
    "Conv�nio"
  ],
  [
    SHIFT_OBSERVATION_FIELD,
    ["String", false, false, false, []],
    "Observa��o"
  ],
  [
    SHIFT_START_TIME_FIELD,
    ["Time", false, false, false, []],
    "Hor�rio de in�cio"
  ],
  [
    SHIFT_STATE_FIELD,
    ["Boolean", false, false, false, []],
    "Estado"
  ]
];
