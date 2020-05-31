class DentistAgreement {
  String _id;
  String _dentistId;
  String _agreementId;

  DentistAgreement( this._id, this._dentistId, this._agreementId);

  String get id => _id;
  set id(String id) => _id = id;

  String get dentistId => _dentistId;
  set dentistId(String dentistId) => _dentistId = dentistId;

  String get agreementId => _agreementId;
  set agreementId(String agreementd) => _agreementId = agreementId;
 
}
