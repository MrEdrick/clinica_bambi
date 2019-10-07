import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import '../../controller/factory_field.dart';
import '../../model/constants.dart';
import '../../model/collection.dart';

@Component(
    selector: 'expasion-panel-group-select-component',
    styleUrls: const [
      'expasion_panel_group_select_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'expasion_paneil_group_select_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialExpansionPanel,
      MaterialIconComponent
    ])

class ExpasionPanelGroupSelectComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  String title;

  @Input()
  List<Collection> collectionList;

  @Input()
  ComponentRef componentRef;

  @ViewChild('viewContainerRefEditField', read: ViewContainerRef)
  ViewContainerRef viewContainerRefEditField;

  ExpasionPanelGroup(this._changeDetectorRef);

  void ngOnInit() async {
    collectionList.forEach((collection) {
      if (collection.type == COLLECTION_TYPE_SINGLE_FIELD) {
        if (collection.fieldList.first.type == FIELD_TYPE_BOOLEAN) {
          new FactoryField(field, _loader, viewContainerRefEditField).addField();
        }
      }
      if (collection.type == COLLECTION_TYPE_LINK) {
        collection.fieldList.forEach((field) {
          if (field.type == FIELD_TYPE_FOREIGN_KEY_DEPENDENT) {
            new FactoryField(field, _loader, viewContainerRefEditField).addField();
          }
        });
      }
    });

    _changeDetectorRef..markForCheck();
  }
}
