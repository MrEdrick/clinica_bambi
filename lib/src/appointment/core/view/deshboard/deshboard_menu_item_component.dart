import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../model/file.dart';

import '../deshboard_menu_sub_item_component.template.dart'
    as deshboard_menu_sub_item_component;

@Component(
  selector: 'deshboard_menu_item_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_menu_item_component.html',
  directives: const [
    coreDirectives,
    materialInputDirectives,
    MaterialIconComponent
  ],
  providers: const [
    materialProviders,
    windowBindings,
    datepickerBindings,
    popupBindings
  ],
  styleUrls: const [
    'deshboard_menu_item_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardMenuItemComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  final List<ComponentRef> listComponentRefMenuSubItem = new List<ComponentRef>();

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  @Input()
  ComponentRef componentRef;

  @Input()
  File file;

  @Output('onClickMenuItem')
  get onClickMenuItem => new StreamController<void>();

  DeshboardMenuItemComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    listComponentRefMenuSubItem.clear();
    
    file.collectionList.forEach((collection) {
      ComponentFactory<deshboard_menu_sub_item_component.DeshboardMenuSubItemComponent>
        componentFactoryDeshboardMenuSubItem =
        deshboard_menu_sub_item_component.DeshboardMenuSubItemComponentNgFactory;
    
      listComponentRefMenuSubItem.add(_loader.loadNextToLocation(componentFactoryDeshboardMenuSubItem, viewContainerRefMenuItem));

      listComponentRefMenuSubItem.last.instance.onClickMenuItem.listen((_) => onClickMenuItem());
      listComponentRefMenuSubItem.last.collection = collection;
      listComponentRefMenuSubItem.last.componentRef = listComponentRefMenuSubItem.last;
    });
    
    _changeDetectorRef.markForCheck();
  }
}
