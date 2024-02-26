import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tikeri/models/weather_model.dart';
import '../repositories/weather_loc_repo.dart';

class WeatherBloc extends Cubit<WeatherState> {
  final WeatherRepositoryLoc weatherRepository;

  WeatherBloc({required this.weatherRepository}) : super(WeatherInitial());

  Future<void> getWeather(String location) async {
    try {
      final weather = await weatherRepository.fetchWeather(location);
      emit(WeatherLoaded(weather: weather));
    } catch (e) {
      emit(WeatherError());
    }
  }
}

class WeatherState {}

class WeatherInitial extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;

  WeatherLoaded({required this.weather});
}

class WeatherError extends WeatherState {}
