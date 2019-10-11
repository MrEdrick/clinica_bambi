class ModalConfiguration {
  String _title;
  String _message;
  String _confirmationMessage;
  String _disconfirmationMessage;
  String _type;

  ModalConfiguration(this._title, this._message, this._confirmationMessage,
      this._disconfirmationMessage, this._type);

  String get title => _title;
  set title(String title) => _title = title;

  String get message => _message;
  set message(String message) => _message = message;

  String get confirmationMessage => _confirmationMessage;
  set confirmationMessage(String confirmationMessage) =>
      _confirmationMessage = confirmationMessage;

  String get disconfirmationMessage => _disconfirmationMessage;
  set disconfirmationMessage(String disconfirmationMessage) =>
      _disconfirmationMessage = disconfirmationMessage;

  String get type => _type;
  set type(String type) => _type = type;
}
