import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import '../../appointment/appointment_scheduling/appointment_scheduling_service.dart';
import '../../appointment/user/user_service.dart';
import 'package:intl/intl.dart';
import 'package:ClinicaBambi/src/deshboard_appointment/appointment_scheduling/appointment_scheduling_card_component.template.dart'
    as appointment_scheduling_card;

@Component(
    selector: 'appointment_scheduling_list_component.',
    changeDetection: ChangeDetectionStrategy.OnPush,
    styleUrls: const [
      'appointment_scheduling_list_component.scss.css',
      'package:angular_components/app_layout/layout.scss.css'
    ],
    templateUrl: 'appointment_scheduling_list_component.html',
    directives: const [
      coreDirectives,
      formDirectives,
      AutoFocusDirective,
      materialInputDirectives,
      MaterialInputComponent,
      materialInputDirectives,
      ModalComponent,
    ])
class AppointmentSchedulingListComponent implements OnInit {
  final ChangeDetectorRef _changeDetectorRef;
  final ComponentLoader _loader;

  AppointmentSchedulingListComponent(this._loader, this._changeDetectorRef);

  @Input()
  Date date;

  @Input()
  ComponentRef componentRef;

  String dateFormated;

  int totalResultByDay;

  bool showDeteleCertification = false;

  @ViewChild('containerCardAppointmentScheduling', read: ViewContainerRef)
  ViewContainerRef materialContainerCard;

  void ngOnInit() {
    if (new UserService().user == null) return;

    dateFormated =
        new DateFormat("EEEE, dd 'de' MMMM 'de' yyyy").format(date.asUtcTime());

    List<Map> _list = new AppointmentSchedulingService()
        .getAppointmentSchedulingFromListWithFilterByDate(date);

    _list.forEach((appointmentScheduling) {
      ComponentFactory<
              appointment_scheduling_card.AppointmentSchedulingCardComponent>
          appointmentSchedulingCard = appointment_scheduling_card
              .AppointmentSchedulingCardComponentNgFactory;

      ComponentRef appointmentSchedulingCardComponent = _loader
          .loadNextToLocation(appointmentSchedulingCard, materialContainerCard);

      appointmentSchedulingCardComponent.instance.appointmentSchedulingId =
          appointmentScheduling["documentPath"];
      appointmentSchedulingCardComponent.instance.componentRef =
          appointmentSchedulingCardComponent;
    });

    _changeDetectorRef.markForCheck();
  }
}
