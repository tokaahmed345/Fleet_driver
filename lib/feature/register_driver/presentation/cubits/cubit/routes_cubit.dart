import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fleet_driver/feature/register_driver/domain/entity/route_entity.dart';
import 'package:fleet_driver/feature/register_driver/domain/usecase/route_usecase.dart';

part 'routes_state.dart';

class RoutesCubit extends Cubit<RoutesState> {
  RoutesCubit(this.useCase) : super(RoutesInitial());
  final GetAllRoutesUseCase useCase;

 Future<void> getRoutes() async {
    emit(RoutesLoading());

    final result = await useCase.call();

    result.fold(
      (failure) => emit(RoutesFailure(failure.message)),
      (routes) => emit(RoutesSuccess(routes)),
    );
  }

}
