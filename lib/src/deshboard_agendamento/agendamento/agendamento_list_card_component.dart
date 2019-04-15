import 'dart:html';
import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:intl/intl.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'agendamento_card_component.dart';
import '../../firebase/firestore.dart';
import '../../agendamento/consulta/appointment_scheduling_constants.dart';
import '../../agendamento/consulta/consulta_service.dart';
import '../../agendamento/consulta/consulta.dart';
import '../../agendamento/user/user.dart';
import '../../agendamento/dentist/dentist_service.dart';
import '../../agendamento/shift/shift_service.dart';
import '../../agendamento/agreement/agreement_service.dart';
import '../../agendamento/user/user_service.dart';
import 'package:ClinicaBambi/src/deshboard_agendamento/agendamento/agendamento_card_component.template.dart'
    as agendamento_card;

@Component(
    selector: 'agendamento_list_card_component.',
    styleUrls: const [
      'agendamento_list_card_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'agendamento_list_card_component.html',
    //changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      NgFor,
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AgendamentoCardComponent,
      MaterialIconComponent,
      MaterialButtonComponent,
      MaterialInputComponent,
      materialInputDirectives,
      MaterialDialogComponent,
      ModalComponent,
    ])
class AgendamentoListCardComponent implements OnInit {
  final ComponentLoader _loader;

  final List<String> listAppointmentSchedulingId = new List<String>();

  User _user;

  AgendamentoListCardComponent(this._loader);

  User get user => _user;
  @Input()
  set user(User user) => _user = user;

  @Input()
  Date date;

  @Input()
  String dentistId;

  @Input()
  String shiftId;

  @Input()
  String patientName;

  @Input()
  int index;

  int totalResultByDay;

  bool showDeteleCertification = false;

  int deleteIndex = -1;

  @ViewChild('containerCardAgendamento', read: ViewContainerRef)
  ViewContainerRef materialContainerList;

  void ngOnInit() {
    if (new UserService().user == null) return;

    List<Map> _list = new ConsultaService().getAppointmentSchedulingFromListWithFilterByDate(date.toString());
    _list.forEach((appointmentScheduling) {
      ComponentFactory<agendamento_card.AgendamentoCardComponent>
          agendamentoCard =
          agendamento_card.AgendamentoCardComponentNgFactory;

      ComponentRef agendamentoListComponent =
        _loader.loadNextToLocation(agendamentoCard, materialContainerList);

      agendamentoListComponent.instance.appointmentSchedulerId = appointmentScheduling["documentPath"];
    });
    //selectItensFireBase();
  }

  void selectItensFireBase() async {
    List<Map> _listDocumentSnapshot = new List<Map>();

    totalResultByDay = 0;

    totalResultByDay = _listDocumentSnapshot.length;

    if (totalResultByDay == 0) {
      querySelector("#agendamento-list-card-app-" + index.toString())
          ?.parent
          ?.remove();
      return;
    }

    int totalResult;

    if (querySelector('#agendamento-result-filter-text')
            .getAttribute('value') ==
        null) {
      totalResult = 0;
    } else {
      totalResult = int.parse(querySelector('#agendamento-result-filter-text')
          .getAttribute('value')
          .toString());
    }

    totalResult = totalResult + totalResultByDay;
    querySelector('#agendamento-result-filter-text')
        .setAttribute('value', totalResult?.toString());
    querySelector('#agendamento-result-filter-text')
        .setInnerHtml(totalResult?.toString());

    listAppointmentSchedulingId.clear();

    _listDocumentSnapshot.forEach((doc) async {
      listAppointmentSchedulingId.add(doc['documentPath']);
    });

  }

  void onDelete(int index) {
    deleteIndex = index;
    showDeteleCertification = true;
  }

  void deleteConsulta() {
    FireStoreApp _fireStoreApp =
        new FireStoreApp(APPOINTMENT_SCHEDULING_COLLECTION);
    _fireStoreApp.deleteItem(listAppointmentSchedulingId[deleteIndex]);
    _fireStoreApp.FireStoreOffLine();
    listAppointmentSchedulingId.removeAt(deleteIndex);
    showDeteleCertification = false;
    deleteIndex = -1;
  }

  void noDeleteConsulta() {
    showDeteleCertification = false;
    deleteIndex = -1;
  }
}
