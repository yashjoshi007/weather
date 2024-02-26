import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/blocs/weat_loc_bloc.dart';

class WeatherPageLoc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final WeatherBloc weatherBloc = BlocProvider.of<WeatherBloc>(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter location',
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (value) {
                  weatherBloc.getWeather(value);
                },
              ),
              SizedBox(height: 20),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoaded) {
                    return Column(
                      children: [
                        Text('Weather: ${state.weather.description}', style: GoogleFonts.poppins()),
                        Text('Temperature: ${state.weather.temperature.toString()}°C', style: GoogleFonts.poppins()),
                      ],
                    );
                  } else if (state is WeatherError) {
                    return Text('Failed to fetch weather data', style: GoogleFonts.poppins());
                  }
                  return CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
