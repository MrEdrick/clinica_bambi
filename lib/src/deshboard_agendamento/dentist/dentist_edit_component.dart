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
import 'package:angular_components/material_select/material_dropdown_select.dart';
import 'package:angular_components/material_select/material_dropdown_select_accessor.dart';
import 'package:intl/intl.dart';

import '../../agendamento/dentist/dentist_service.dart';
import '../../agendamento/dentist/dentist_constants.dart';

import '../../firebase/firestore.dart';

import '../../agendamento/user/user_service.dart';

import 'package:ClinicaBambi/src/deshboard_agendamento/quantity_per_shift_by_day/quantity_per_shift_by_day_group_checkbox_component.template.dart'
    as quantity_per_shift_by_day_group_checkbox_component;

@Component(
    selector: 'dentist_edit_component',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const [
      'dentist_edit_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'dentist_edit_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      MaterialCheckboxComponent,
      materialInputDirectives,
      MaterialDropdownSelectComponent,
      DropdownSelectValueAccessor,
      MaterialDialogComponent,
      ModalComponent,
      AutoDismissDirective,
    ],
    providers: [windowBindings, datepickerBindings])
class DentistEditComponent implements OnInit {
  final ComponentLoader _loader;
  final ChangeDetectorRef _changeDetectorRef;

  @Input()
  ComponentRef componentRef;

  DentistService _dentistService;

  @ViewChild('quantityPerShiftByDayGroupCheckboxComponent',
      read: ViewContainerRef)
  ViewContainerRef materialContainerDayGroupCheckbox;

  DentistService get dentistService => _dentistService;
  set dentistService(DentistService dentistService) =>
      _dentistService = dentistService;

  bool showSuccessfullySave = false;
  bool showNotSuccessfullySave = false;
  bool useItemRenderer = false;
  bool useOptionGroup = false;
  bool showAssertMessageSave = false;
  bool showAssertMessageAlert = false;

  String name = '';
  bool state;

  Map<String, dynamic> datas;

  DentistEditComponent(this._changeDetectorRef, this._loader);

  void onEdit() {
    dentistService = new DentistService();

    if (dentistService.dentist != null) {
      name = dentistService.dentist.name;
      state = dentistService.dentist.state == 'A';
    }
  }

  void ngOnInit() {
    if (new UserService().user == null) return;

    onEdit();

    List _list = [1, 2, 3, 4, 5, 6, 7];

    _list.forEach((day) {
      ComponentFactory<
              quantity_per_shift_by_day_group_checkbox_component
                  .QuantityPerShiftByDayGroupCheckboxComponent>
          agendamentoCard = quantity_per_shift_by_day_group_checkbox_component
              .QuantityPerShiftByDayGroupCheckboxComponentNgFactory;

      ComponentRef quantityPerShiftByDayGroupCheckboxComponentComponent =
          _loader.loadNextToLocation(
              agendamentoCard, materialContainerDayGroupCheckbox);

      quantityPerShiftByDayGroupCheckboxComponentComponent.instance.dayOfWeek =
          Date(day).weekday;
    });

    _changeDetectorRef.markForCheck();
  }

  void onClose() {
    name = '';
    state = true;

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
    if ((name == '')) {
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

    datas = {"name": name, "state": state ? 'A' : 'I'};

    FireStoreApp _fireStoreApp = new FireStoreApp(DENTIST_COLLECTION);

    if (dentistService.dentist != null
        ? await _fireStoreApp.updateItem(dentistService.dentist?.id, datas)
        : await _fireStoreApp.addItem(datas)) {
      showSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    } else {
      showNotSuccessfullySave = true;
      _fireStoreApp.FireStoreOffLine();
    }
  }
}
