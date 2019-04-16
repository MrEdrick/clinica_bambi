import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'agendamento_card_component.dart';
import '../../agendamento/consulta/consulta_service.dart';
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
    changeDetection: ChangeDetectionStrategy.OnPush,
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      AgendamentoCardComponent,
      MaterialInputComponent,
      materialInputDirectives,
      ModalComponent,
    ])
class AgendamentoListCardComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef; 
  final ComponentLoader _loader;

  final List<String> listAppointmentSchedulingId = new List<String>();

  AgendamentoListCardComponent(this._loader, this._changeDetectorRef);

  @Input()
  Date date;

  int totalResultByDay;

  bool showDeteleCertification = false;

  @ViewChild('containerCardAgendamento', read: ViewContainerRef)
  ViewContainerRef materialContainerCard;

  void ngOnInit() {
    if (new UserService().user == null) return;

    List<Map> _list = new ConsultaService().getAppointmentSchedulingFromListWithFilterByDate(date.toString());
    _list.forEach((appointmentScheduling) {
      ComponentFactory<agendamento_card.AgendamentoCardComponent>
          agendamentoCard =
          agendamento_card.AgendamentoCardComponentNgFactory;

      ComponentRef agendamentoListComponent =
        _loader.loadNextToLocation(agendamentoCard, materialContainerCard);

      agendamentoListComponent.instance.appointmentSchedulerId = appointmentScheduling["documentPath"];
      agendamentoListComponent.instance.componentRef = agendamentoListComponent;
    });
    
    _changeDetectorRef.markForCheck();
  }

  void selectItensFireBase() async {
    List<Map> _listDocumentSnapshot = new List<Map>();

    totalResultByDay = 0;

    totalResultByDay = _listDocumentSnapshot.length;

    //if (totalResultByDay == 0) {
    //  querySelector("#agendamento-list-card-app-" + index.toString())
    //      ?.parent
    //      ?.remove();
    //  return;
    //}

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

}
