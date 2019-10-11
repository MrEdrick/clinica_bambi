class CollectionType {
  String _type;
  bool _hasSetLimit;

  CollectionType(this._type, this._hasSetLimit);

  String get type => _type;
  set type(String type) => _type = type;

  bool get hasSetLimit => _hasSetLimit;
  set hasSetLimit(bool hasSetLimit) => _hasSetLimit = hasSetLimit;
}
