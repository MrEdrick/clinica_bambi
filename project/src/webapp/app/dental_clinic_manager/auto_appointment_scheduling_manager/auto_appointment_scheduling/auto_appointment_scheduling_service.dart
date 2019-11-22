import '../../../../core/constants/constants.dart';
import '../../../../core/dao/condition.dart';
import '../../../../core/dao/order_by.dart';
import '../../../../core/controller/service/service.dart';

import 'auto_appointment_scheduling.dart';
import 'auto_appointment_scheduling_constants.dart';
import 'auto_appointment_scheduling_dao.dart';

class AutoAppointmentSchedulingService extends Service {
  AutoAppointmentSchedulingService() : super() {
    super.dao = new AutoAppointmentSchedulingDAO();
    super.orderBy =
        new OrderBy(AUTO_APPOINTMENT_SCHEDULING_FIELD_ID, ORDER_BY_ASC);
    super.conditionList
      ..clear()
      ..add(new Condition(
          AUTO_APPOINTMENT_SCHEDULING_FIELD_PATIENT, "", CONDITION_HAS));
  }

  AutoAppointmentScheduling get autoAppointmentScheduling => convertMap();

  @override
  List<Map> getListWithFilter() {
    return super.getListWithFilter();
  }

  AutoAppointmentScheduling returnEmpty() {
    return new AutoAppointmentScheduling(
        "", "", "", "", "", "", "", "", "", "", null, null, null, null);
  }

  AutoAppointmentScheduling convertMap() {
    return new AutoAppointmentScheduling(
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_ID],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_SHIFT_ID],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_DENTIST_ID],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_AGREEMENT_ID],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_PROCEDURE_ID],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_PATIENT],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_EMAIL],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_TELEPHONE],
        super
            .map[AUTO_APPOINTMENT_SCHEDULING_FIELD_DATE_APPOINTMENT_SCHEDULING],
        super.map[AUTO_APPOINTMENT_SCHEDULING_FIELD_PATIENT_ACCOUNT_ID]);
  }
}
