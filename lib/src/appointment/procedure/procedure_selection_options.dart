import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';

class ProcedureSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {
  ProcedureSelectionOptions(List<T> options)
      : super(options, toFilterableString: (T option) => option.toString());
  ProcedureSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
            toFilterableString: (T option) => option.toString());
  @override
  SelectableOption getSelectable(item) =>
          SelectableOption.Selectable;
}