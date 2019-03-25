class Email {
  String _senderEmail;
  String _senderPassword;
  String _receiver;
  String _subject;
  String _content;
  String _contentType;
  String _mime;

  Email( this._senderEmail, this._senderPassword, this._receiver, this._subject, 
         this._content, this._contentType, this._mime);

  String get senderEmail => _senderEmail;
  set senderEmail(String senderEmail) => _senderEmail = senderEmail;

  String get senderPassword => _senderPassword;
  set senderPassword(String senderPassword) => _senderPassword = senderPassword;

  String get receiver => _receiver;
  set receiver(String receiver) => _receiver = receiver;

  String get subject => _subject;
  set subject(String subject) => _subject = subject;

  String get content => _content;
  set content(String content) => _content = content;

  String get contentType => _contentType;
  set contentType(String contentType) => _contentType = contentType;

  String get mime => _mime;
  set mime(String mime) => _mime = mime;
}
