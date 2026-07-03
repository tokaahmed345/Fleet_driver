import 'package:bloc/bloc.dart';
import 'package:fleet_driver/feature/log_free_seats/domain/use_case/get_pending_logs_use_case.dart';

class PendingLogsCubit extends Cubit<int> {
  final GetPendingLogsUseCase getPendingLogsUseCase;

  PendingLogsCubit(this.getPendingLogsUseCase) : super(0);

  Future<void> refresh() async {
    final result = await getPendingLogsUseCase();
    if (isClosed) return;
    result.fold(
      (failure) {}, 
      (logs) => emit(logs.length),
    );
  }
}