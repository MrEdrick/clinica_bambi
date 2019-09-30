import 'dart:html';
import 'package:ClinicaBambi/src/appointment/procedure/procedure.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../controller/service.dart';
import '../../../appointment/user/user_service.dart';

@Component(
    selector: 'edit-app',
    styleUrls: const [
      'edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      MaterialCheckboxComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [
      windowBindings
    ])
class EditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  final List<ComponentRef> listComponentRefProcedureRequirement = new List<ComponentRef>();

  Service service;

  @Input()
  ComponentRef componentRef;

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  EditComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    procedureService = new ProcedureService();

    if (procedureService.procedure == null) { 
      procedureService.procedure = new Procedure("", "", true);
    }
  }


  void onClearListsOfComponentRef() {
    listComponentRefProcedureRequirement.forEach((componentRef) {
      componentRef.destroy();
    });

    listComponentRefProcedureRequirement.clear();
  }

  void ngOnInit() async {
    if (new UserService().user  == null)
      return;

    onClearListsOfComponentRef();

    querySelector('deshboard_appointment_component').style.overflowY = "hidden";
    onEdit();

    List<Requirement> _listRequirement = await new RequirementService().getAllRequirementAcives();

    await new ProcedureRequirementService().getAllProcedureRequirementAcives();

    _listRequirement.forEach((requirement) {
        ComponentFactory<procedure_requirement_checkbox_component.ProcedureRequirementCheckboxComponent>
            procedureRequirementComponent =
            procedure_requirement_checkbox_component.ProcedureRequirementCheckboxComponentNgFactory;

        procedureRequirementCheckboxComponent =
            _loader.loadNextToLocation(
                procedureRequirementComponent, materialContainerProcedureRequirementCheckBox);

        procedureRequirementCheckboxComponent.instance.procedureId = procedureService.procedure.id;
        procedureRequirementCheckboxComponent.instance.requirementId = requirement.id;
        procedureRequirementCheckboxComponent.instance.requirement = requirement.description;
        
        listComponentRefProcedureRequirement.add(procedureRequirementCheckboxComponent);
    });
    
    _changeDetectorRef.markForCheck();  
  }

  void onClose() {
    procedureService.procedure = null;
    querySelector('deshboard_appointment_component').style.overflowY = "scroll";
    componentRef.destroy();
  }

  bool asserts() {
    return true;
  }

  void onDismissSuccessfullySave() {
    showSuccessfullySave = false;
    onClose();
  }

  void onDismissNotSuccessfullySave() {
    showSuccessfullySave = false;
  }

  void onDismissAssertMessage() {
    showAssertMessageSave = false;
  }

  void onAssertsSave() {
    if ((procedureService.procedure.description == "")) {
      showAssertMessageSave = true;
      return;
    }

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;  
  }

  void onSave() async {   
    showAssertMessageAlert = false;

    if (await procedureService.save()) {
      showSuccessfullySave = true;  
    } else {
      showNotSuccessfullySave = true;
    }
    
    _changeDetectorRef.markForCheck();
  }
}
