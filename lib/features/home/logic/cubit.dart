import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go/features/home/logic/states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeState());
}
