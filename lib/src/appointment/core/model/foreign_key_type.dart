class ForeignKeyType {
  String _type;
  bool _isGuide;
  bool _isDependent;

  ForeignKeyType(this._type, this._isGuide, this._isDependent); 

  String get type => _type;
  set type(String type) => _type = type;

  bool get isGuide => _isGuide;
  set isGuide(bool isGuide) => _isGuide = isGuide;

  bool get isDependent => _isDependent;
  set isDependent(bool isDependent) => _isDependent = isDependent;
}