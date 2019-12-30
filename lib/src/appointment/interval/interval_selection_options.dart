import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';

class IntervalSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {
  IntervalSelectionOptions(List<T> options)
      : super(options, toFilterableString: (T option) => option.toString());
  IntervalSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
            toFilterableString: (T option) => option.toString());
  @override
  SelectableOption getSelectable(item) =>
      //item is Dentist && item.code.contains('en')
          //? SelectableOption.Disabled
          //: 
          SelectableOption.Selectable;
}