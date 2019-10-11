import 'package:angular_components/model/selection/select.dart';
import 'package:angular_components/model/selection/selection_options.dart';
import 'package:angular_components/model/selection/string_selection_options.dart';

class HourSelectionOptions<T> extends StringSelectionOptions<T>
    implements Selectable {
  HourSelectionOptions(List<T> options)
      : super(options, toFilterableString: (T option) => option.toString());
  HourSelectionOptions.withOptionGroups(List<OptionGroup> optionGroups)
      : super.withOptionGroups(optionGroups,
            toFilterableString: (T option) => option.toString());
  @override
  SelectableOption getSelectable(item) =>
      //item is Dentist && item.code.contains('en')
          //? SelectableOption.Disabled
          //: 
          SelectableOption.Selectable;
}