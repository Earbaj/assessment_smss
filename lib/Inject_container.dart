import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'core/network/dio_client.dart';
import 'features/sms_console/data/datasources/sms_remote_data_source.dart';
import 'features/sms_console/data/repositories/sms_repository_impl.dart';
import 'features/sms_console/domain/repositories/sms_repository.dart';
import 'features/sms_console/domain/usecases/get_cost_breakdown_usecase.dart';
import 'features/sms_console/domain/usecases/send_sms_usecase.dart';
import 'features/sms_console/presentation/bloc/sms_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // BLoC
  sl.registerFactory(() => SmsBloc(getCostBreakdownUseCase: sl(), sendSmsUseCase: sl()));

  // Use Cases
  sl.registerLazySingleton(() => GetCostBreakdownUseCase(sl()));
  sl.registerLazySingleton(() => SendSmsUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<SmsRepository>(() => SmsRepositoryImpl(sl()));

  // Data Sources
  sl.registerLazySingleton<SmsRemoteDataSource>(() => SmsRemoteDataSourceImpl(sl()));

  // External (Core Network Services)
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()).dio);
}
