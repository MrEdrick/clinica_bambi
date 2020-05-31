import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_datepicker/module.dart';
import 'package:angular_components/utils/browser/window/module.dart';
import 'package:angular_components/material_checkbox/material_checkbox.dart';

import '../../appointment/user/user_service.dart';

import '../../appointment/dentist_agreement/dentist_agreement_service.dart';
import '../../appointment/dentist_agreement/dentist_agreement.dart';

@Component(
    selector: 'dentist_agreement_checkbox_component',
    styleUrls: const [
      'dentist_agreement_checkbox_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    changeDetection: ChangeDetectionStrategy.OnPush,
    templateUrl: 'dentist_agreement_checkbox_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialCheckboxComponent,
    ],
    providers: [windowBindings, datepickerBindings])
class DentistAgreementCheckboxComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final DentistAgreementService dentistAgreementService =
      new DentistAgreementService();
  bool checked = false;
  String display = "none";

  String dentistAgreementId;

  @Input()
  String agreement = "";

  @Input()
  String agreementId = "";

  @Input()
  String dentistId = "";

  DentistAgreementCheckboxComponent(this._changeDetectorRef);

  void ngOnInit() async {
    if (new UserService().user == null) return;

    if ((dentistId != "") && (dentistId != null)) {
      (await dentistAgreementService.getOneDentistAgreementByFilterFromList(
          {"dentistId": dentistId, "agreementId": agreementId}));

      if (dentistAgreementService.dentistAgreementListByDentistIdAgreementId[
              dentistId + agreementId] ==
          null) {
        dentistAgreementId = "";
      } else {
        dentistAgreementId = dentistAgreementService
            .dentistAgreementListByDentistIdAgreementId[dentistId + agreementId]
            .id;
      }
    } else {
      dentistAgreementId = "";
      dentistAgreementService.dentistAgreement =
          new DentistAgreement("", dentistId, agreementId);
    }

    checked = dentistAgreementId != "";

    onCheckedChange();

    _changeDetectorRef.markForCheck();
  }

  void onCheckedChange() {
    if (checked) {
      display = "block";

      if (dentistAgreementService.dentistAgreementListByDentistIdAgreementId[
              dentistId + agreementId] ==
          null) {
        dentistAgreementService.dentistAgreementListByDentistIdAgreementId[
                dentistId + agreementId] =
            new DentistAgreement("", dentistId, agreementId);
      }

      dentistAgreementService
          .dentistAgreementListByDentistIdAgreementId[dentistId + agreementId]
          .dentistId = dentistId;
      dentistAgreementService
          .dentistAgreementListByDentistIdAgreementId[dentistId + agreementId]
          .agreementId = agreementId;
    } else {
      display = "none";

      if (dentistAgreementService.dentistAgreementListByDentistIdAgreementId[
              dentistId + agreementId] !=
          null) {
        dentistAgreementService
            .dentistAgreementListByDentistIdAgreementId[dentistId + agreementId]
            .dentistId = "";

        dentistAgreementService
            .dentistAgreementListByDentistIdAgreementId[dentistId + agreementId]
            .agreementId = "";
      }
    }

    _changeDetectorRef.markForCheck();
  }
}
