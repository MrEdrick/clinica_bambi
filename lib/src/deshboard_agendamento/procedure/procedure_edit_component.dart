import 'dart:async';
import 'dart:html';
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

import '../../agendamento/procedure/procedure_service.dart';
import '../../agendamento/procedure/procedure_constants.dart';

import '../../firebase/firestore.dart';


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
  bool state = true;

  ProcedureService _procedureService;

  ProcedureService get procedureService => _procedureService;
  set procedureService(ProcedureService procedureService) => _procedureService = procedureService;


  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  String description = '';

  Map<String, dynamic> datas;

  void onEdit() {
    procedureService = new ProcedureService();

    if (procedureService.procedure != null) {

      description = procedureService.procedure.description;
      state = procedureService.procedure.state == 'A';
    }
  }

  void ngOnInit() {
    if (new UserService().user  == null)
      return;

    onEdit();    
  }

  void onClose() {

    description = '';
    state = true;

    querySelector('#procedure-edit-app').style.display = 'none';
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

    onSave();
  }

  void onNoSave() {
    showAssertMessageAlert = false;  
  }

  void onSave() async {   
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
  }
}
