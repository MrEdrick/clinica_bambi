import 'package:angular/angular.dart';

import '../../../model/collection.dart';
import '../../../model/field.dart';

class FactoryField {
  Field _field;
  ComponentLoader _loader;
  ViewContainerRef _viewContainerRefField;
  List<Collection> _collectionListDependent;

  FactoryField(this._field, this._loader, this._viewContainerRefField,
      this._collectionListDependent);

  Field get field => _field;
  set field(Field field) => _field = field;

  ComponentLoader get loader => _loader;
  set loader(ComponentLoader loader) => _loader = loader;

  ViewContainerRef get viewContainerRefField => _viewContainerRefField;
  set viewContainerRefField(ViewContainerRef viewContainerRefField) =>
      _viewContainerRefField = viewContainerRefField;

  List<Collection> get collectionListDependent => _collectionListDependent;
  set collectionListDependent(List<Collection> collectionListDependent) =>
      _collectionListDependent = collectionListDependent;
}
