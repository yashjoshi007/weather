class Weather {
  final String description;
  final double temperature;

  Weather({required this.description, required this.temperature});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      description: json['weather'][0]['description'],
      temperature: json['main']['temp'],
    );
  }
}
class current {
  var temp;
  var pressure;
  var humidity;
  var weather;
  var id;
  var desc;
  current(this.temp,this.desc,this.weather,this.humidity,this.id,this.pressure);
}
class forecast{
  var dt;
  var max;
  var humidity;
  var min;
  var weather;
  var desc;
  forecast( this.dt,this.humidity,this.max,this.min,this.weather,this.desc);
}


