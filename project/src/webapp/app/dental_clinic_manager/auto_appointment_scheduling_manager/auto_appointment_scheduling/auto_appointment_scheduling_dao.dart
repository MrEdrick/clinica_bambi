import '../../../../core/dao/dao.dart';
import '../../../../core/dao/filter.dart';
import 'auto_appointment_scheduling_service.dart';

class AutoAppointmentSchedulingDAO extends DAO {
  AutoAppointmentSchedulingDAO()
      : super(new Filter(
            new AutoAppointmentSchedulingService().returnEmpty(), null, null));
}
