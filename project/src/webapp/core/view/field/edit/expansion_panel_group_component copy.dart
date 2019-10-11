import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import '../../../controller/factory/field/factory_edit_field.dart';
import '../../../constants/constants.dart';
import '../../../model/collection/collection.dart';

@Component(
    selector: 'expasion-panel-group-component',
    styleUrls: const [
      'expasion_panel_group_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'expasion_paneil_group_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialExpansionPanel,
      MaterialIconComponent
    ])
class ExpasionPanelGroupComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  String title;

  @Input()
  List<Collection> collectionList;

  @Input()
  ComponentRef componentRef;

  @ViewChild('viewContainerRefEditField', read: ViewContainerRef)
  ViewContainerRef viewContainerRefEditField;

  ExpasionPanelGroupComponent(this._loader, this._changeDetectorRef);

  void ngOnInit() async {
    collectionList.forEach((collection) {
      if (collection.type.type == COLLECTION_TYPE_FINAL) {
        if (collection.fieldList.first.type.type == FIELD_TYPE_VALUE_BOOLEAN) {
          new FactoryEditField(collection.fieldList.first, _loader,
                  viewContainerRefEditField, collectionList)
              .addField();
        }
      }
      if (collection.type.type == COLLECTION_TYPE_LINK) {
        collection.fieldList.forEach((field) {
          if (field.type.type == FIELD_TYPE_FOREIGN_KEY) {
            new FactoryEditField(
                    field, _loader, viewContainerRefEditField, collectionList)
                .addField();
          }
        });
      }
    });

    _changeDetectorRef..markForCheck();
  }
}
