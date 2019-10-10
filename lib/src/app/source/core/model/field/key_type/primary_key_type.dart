class PrimaryKeyType {
  bool _isComposed;

  PrimaryKeyType(this._isComposed); 

  bool get isComposed => _isComposed;
  set isComposed(bool isComposed) => _isComposed = isComposed;
}