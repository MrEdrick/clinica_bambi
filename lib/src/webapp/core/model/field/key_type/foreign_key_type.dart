class ForeignKeyType {
  bool _isGuide;
  bool _isDependent;

  ForeignKeyType(this._isGuide, this._isDependent); 

  bool get isGuide => _isGuide;
  set isGuide(bool isGuide) => _isGuide = isGuide;

  bool get isDependent => _isDependent;
  set isDependent(bool isDependent) => _isDependent = isDependent;
}