import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../model/collection.dart';

@Component(
  selector: 'deshboard_menu_sub_item_component',
  changeDetection: ChangeDetectionStrategy.OnPush,
  templateUrl: 'deshboard_menu_sub_item_component.html',
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
    'deshboard_menu_sub_item_component.scss.css',
    'package:angular_components/app_layout/layout.scss.css'
  ],
)
class DeshboardMenuSubItemComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool overlay = true;

  @Input()
  ComponentRef componentRef;
  
  @Input()
  Collection collection;

  @Output('onClickMenuItem')
  get onClickMenuItem => new StreamController<void>();

  DeshboardMenuSubItemComponent(this._changeDetectorRef);

  void ngOnInit() async {
    _changeDetectorRef.markForCheck();
  }
}
