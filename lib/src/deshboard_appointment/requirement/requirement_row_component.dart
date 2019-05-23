import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';

import '../../appointment/requirement/requirement.dart';
import '../../appointment/requirement/requirement_dao.dart';
import '../../appointment/requirement/requirement_service.dart';
import 'package:ClinicaBambi/src/deshboard_appointment/requirement/requirement_edit_component.template.dart'
    as requirement_edit;

@Component(
    selector: 'requirement_row_component',
    styleUrls: const [
      'requirement_row_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'requirement_row_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
    ])
class RequirementRowComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;
  Requirement requirement;
  RequirementService requirementService = new RequirementService();

  bool showEditAgendamentoEditApp = false;
  bool showDeteleCertification = false;

  @Input()
  String requirementId;

  @Input()
  ComponentRef componentRef;

  @ViewChild('containerEditRequirement', read: ViewContainerRef)
  ViewContainerRef materialContainerEdit;

  RequirementRowComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    requirement = await requirementService.getRequirementById(requirementId);
    _changeDetectorRef.markForCheck();
  }

  void onEdit() {
    requirementService.requirement = requirement;
    ComponentFactory<requirement_edit.RequirementEditComponent>
        requirementEdit = requirement_edit.RequirementEditComponentNgFactory;

    ComponentRef requirementEditComponent = _loader.loadNextToLocation(requirementEdit, materialContainerEdit);
    requirementEditComponent.instance.componentRef = requirementEditComponent;
  }

  void onDelete() {
    showDeteleCertification = true;
  }

  void delete() {
    new RequirementDAO().delete(requirementId);   
    showDeteleCertification = false;
    componentRef.destroy();
  }

  void noDelete() {
    showDeteleCertification = false;
  }
}
