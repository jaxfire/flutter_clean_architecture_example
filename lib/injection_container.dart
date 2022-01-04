import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_clean_arch_learning/common/network/network_info.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_local_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/data/repositories/number_trivia_repository_impl.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_concrete_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/domain/use_cases/get_random_number_trivia.dart';
import 'package:tdd_clean_arch_learning/number_trivia_feature/presentation/bloc/number_trivia_bloc.dart';

import 'number_trivia_feature/domain/repositories/number_trivia_repository.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Features
  // BLoC
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTriviaUseCase: sl(),
      getRandomNumberTriviaUseCase: sl(),
      typeConverter: sl()));
  // Use cases
  sl.registerLazySingleton(() => GetConcreteNumberTriviaUseCase(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTriviaUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(
    () => NumberTriviaRepositoryImpl(
      networkInfo: sl(),
      localDataSource: sl(),
      remoteDataSource: sl(),
    ),
  );
  // Data sources
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sl()));

  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));

  // Common
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton(() => sharedPreferences);
  // Http client
  sl.registerSingleton(() => http.Client);
  // InternetConnectionChecker
  sl.registerLazySingleton(() => InternetConnectionChecker());
}
