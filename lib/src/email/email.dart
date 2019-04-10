class Email {
  String _sender;
  String _receiver;
  String _subject;
  String _message;
  String _contentType;
  String _mime;

  Email( this._sender, this._receiver, 
         this._subject, this._message, this._contentType, this._mime);

  String get sender => _sender;
  set sender(String sender) => _sender = sender;

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
