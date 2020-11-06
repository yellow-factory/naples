import 'package:naples/src/navigation/navigation.dart';

//Possible transition states
enum StandardFlow { List, Create, Update }

// T is the type of the param used to navigate from list to update
class ListCreateUpdateStandardNavigationModel extends NavigationModel<StandardFlow> {
  ListCreateUpdateStandardNavigationModel() : super(StandardFlow.List) {
    addTransition(StandardFlow.List, StandardFlow.Create);
    addTransition(StandardFlow.List, StandardFlow.Update);
  }
}
