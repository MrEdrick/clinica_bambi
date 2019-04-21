import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_toggle/material_toggle.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';

import 'procedure_card_component.dart';

import '../../agendamento/procedure/procedure.dart';
import '../../agendamento/procedure/procedure_constants.dart';

import '../../firebase/firestore.dart';
import '../../agendamento/user/user.dart';
import '../../agendamento/user/user_service.dart';

@Component(
    selector: 'procedure_list_component',
    styleUrls: const [
      'procedure_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'procedure_list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      ProcedureCardComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
      MaterialToggleComponent
    ])
class ProcedureListComponent implements OnInit {
  bool state = true;

  final List<Procedure> listProcedure = new List<Procedure>();

  ProcedureListComponent();

  int totalResultByDay;

  bool showDeteleCertification = false;

  void ngOnInit() {
    if (new UserService().user == null) 
      return;
  }
}
