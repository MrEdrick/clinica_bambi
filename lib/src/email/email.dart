class Email {
  String _senderName;
  String _senderEmail;
  String _senderPassword;
  String _receiver;
  String _subject;
  String _message;
  String _contentType;
  String _mime;

  Email( this._senderName, this._senderEmail, this._senderPassword, this._receiver, 
         this._subject, this._message, this._contentType, this._mime);

  String get senderName => _senderName;
  set senderName(String senderName) => _senderName = senderName;

  String get senderEmail => _senderEmail;
  set senderEmail(String senderEmail) => _senderEmail = senderEmail;

  String get senderPassword => _senderPassword;
  set senderPassword(String senderPassword) => _senderPassword = senderPassword;

  String get receiver => _receiver;
  set receiver(String receiver) => _receiver = receiver;

  String get subject => _subject;
  set subject(String subject) => _subject = subject;

  String get message => _message;
  set message(String message) => _message = message;

  String get contentType => _contentType;
  set contentType(String contentType) => _contentType = contentType;

  String get mime => _mime;
  set mime(String mime) => _mime = mime;
}
