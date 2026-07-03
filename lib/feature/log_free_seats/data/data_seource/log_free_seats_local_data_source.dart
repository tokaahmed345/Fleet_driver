import 'package:hive/hive.dart';
import '../models/free_seats_log_model.dart';


class LogFreeSeatsLocalDataSource  {
  static const boxName = 'pending_seats_logs';

  Future<Box<FreeSeatsLogModel>> _openBox() async {
    return await Hive.openBox<FreeSeatsLogModel>(boxName);
  }
  @override
  Future<void> cacheLog(FreeSeatsLogModel log) async {
        final _box = await _openBox();

    await _box.add(log);
  }

  @override
  Future<List<FreeSeatsLogModel>> getUnsyncedLogs() async {
            final _box = await _openBox();

    return _box.values.where((l) => !l.synced).toList();
  }

  @override
  Future<void> markAsSynced(FreeSeatsLogModel log) async {
            final _box = await _openBox();

    log.synced = true;
    await log.save(); 
  }
}