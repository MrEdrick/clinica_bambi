import 'dart:html';
import 'package:ClinicaBambi/src/agendamento/procedure/procedure.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';

import '../../agendamento/requirement/requirement.dart';
import '../../agendamento/requirement/requirement_service.dart';

import '../../agendamento/procedure/procedure_service.dart';

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'procedure-edit-app',
    styleUrls: const [
      'procedure_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'procedure_edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [
      windowBindings,
      datepickerBindings
    ])
class ProcedureEditComponent implements OnInit {
  ProcedureService _procedureService;

  ProcedureService get procedureService => _procedureService;
  set procedureService(ProcedureService procedureService) => _procedureService = procedureService;

  @Input()
  ComponentRef componentRef;

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  String description = '';

 
  void onEdit() {
    procedureService = new ProcedureService();

    if (procedureService.procedure == null) { 
      procedureService.procedure = new Procedure("", "", true);
    }
  }

  void ngOnInit() async {
    if (new UserService().user  == null)
      return;

    querySelector('deshboard-app').style.overflowY = "hidden";

    List<Requirement> _listRequirement = await new RequirementService().getAllRequirementAcives();

    _listRequirement.forEach((requirement) {
        ComponentFactory<requirement_checkbox_component.RequirementCheckboxComponent>
            requirementComponent =
            Requirement_checkbox_component.RequirementCheckboxComponentNgFactory;

        requirementCheckboxComponent =
            _loader.loadNextToLocation(
                requirementComponent, materialContainerRequirement);

        requirementCheckboxComponent.instance.procedureId = procedureService.procedure.id;
        requirementCheckboxComponent.instance.requirementId = requirement.id;
        requirementCheckboxComponent.instance.requirement = requirement.description;

        listComponentRefRequirement.add(requirementCheckboxComponent);
    });

    onEdit();    
  }

  void onClose() {
    procedureService.procedure = null;
    querySelector('deshboard-app').style.overflowY = "scroll";
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
    if ((description == '')) {

      showAssertMessageSave = true;
      return;
    }

    //onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;  
  }

  /*void onSave() async {   
    showAssertMessageAlert = false;

    datas = new Map<String, dynamic>();

    datas = {
      "description": description,
      "state": state ? 'A' : 'I'
    };

    FireStoreApp _fireStoreApp = new FireStoreApp(PROCEDURE_COLLECTION);

    if (procedureService.procedure != null
        ? await _fireStoreApp.updateItem(procedureService.procedure?.id, datas)
        : await _fireStoreApp.addItem(datas)) {
      showSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    } else {
      showNotSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    }
  }*/
}
