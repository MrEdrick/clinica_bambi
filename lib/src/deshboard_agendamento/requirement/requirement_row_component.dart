import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/material_button/material_button.dart';

import '../../agendamento/requirement/requirement.dart';
import '../../agendamento/requirement/requirement_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/requirement/requirement_edit_component.template.dart'
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
      ModalComponent,
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
  String procedureId;

  @Input()
  ComponentRef componentRef;

  RequirementRowComponent(this._changeDetectorRef, this._loader);

  void ngOnInit() async {
    requirement = await requirementService.getRequirementById(procedureId);
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
