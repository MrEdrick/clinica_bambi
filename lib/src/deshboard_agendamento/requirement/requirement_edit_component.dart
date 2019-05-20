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
import 'package:angular_components/material_checkbox/material_checkbox.dart';
import 'package:angular_components/utils/browser/window/module.dart';

import '../../agendamento/requirement/requirement_service.dart';
import '../../agendamento/requirement/requirement.dart';

import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'requirement-edit-app',
    styleUrls: const [
      'requirement_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'requirement_edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [
      windowBindings
    ])
class RequirementEditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  RequirementService _requirementService;

  RequirementService get requirementService => _requirementService;
  set requirementService(RequirementService requirementService) => _requirementService = requirementService;

  @Input()
  ComponentRef componentRef;

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  Map<String, dynamic> datas;

  RequirementEditComponent(this._loader, this._changeDetectorRef);

    void onEdit() {
    requirementService = new RequirementService();

    if (requirementService.requirement == null) { 
      requirementService.requirement = new Requirement("", "", true);
    }
  }


  void ngOnInit() {
    if (new UserService().user  == null)
      return;

    querySelector('deshboard-app').style.overflowY = "hidden";
    
    onEdit();

    _changeDetectorRef.markForCheck();  
  }

  void onClose() {
    requirementService.requirement = null;
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
    if ((requirementService.requirement.description == '')) {

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

    if (await requirementService.save()) {
      showSuccessfullySave = true;  
    } else {
      showNotSuccessfullySave = true;
    }
    
    _changeDetectorRef.markForCheck();
  }
}
