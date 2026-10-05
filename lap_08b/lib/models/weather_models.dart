class City {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  const City({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'] as String? ?? 'Unknown',
      country: json['country'] as String? ?? '',
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}

class CurrentWeather {
  final double temperature;
  final double apparentTemperature;
  final int relativeHumidity;
  final double windSpeed;
  final double precipitation;
  final int weatherCode;
  final bool isDay;
  final String time;

  const CurrentWeather({
    required this.temperature,
    required this.apparentTemperature,
    required this.relativeHumidity,
    required this.windSpeed,
    required this.precipitation,
    required this.weatherCode,
    required this.isDay,
    required this.time,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: (json['temperature_2m'] as num?)?.toDouble() ?? 0.0,
      apparentTemperature: (json['apparent_temperature'] as num?)?.toDouble() ?? 0.0,
      relativeHumidity: (json['relative_humidity_2m'] as num?)?.toInt() ?? 0,
      windSpeed: (json['wind_speed_10m'] as num?)?.toDouble() ?? 0.0,
      precipitation: (json['precipitation'] as num?)?.toDouble() ?? 0.0,
      weatherCode: (json['weather_code'] as num?)?.toInt() ?? 0,
      isDay: (json['is_day'] as num?)?.toInt() == 1,
      time: json['time'] as String? ?? '',
    );
  }

  // WMO Weather interpretation codes
  String get conditionText {
    switch (weatherCode) {
      case 0:
        return 'Clear Sky';
      case 1:
        return 'Mainly Clear';
      case 2:
        return 'Partly Cloudy';
      case 3:
        return 'Overcast';
      case 45:
      case 48:
        return 'Foggy';
      case 51:
      case 53:
      case 55:
        return 'Drizzle';
      case 61:
      case 63:
      case 65:
        return 'Rain';
      case 71:
      case 73:
      case 75:
        return 'Snowfall';
      case 80:
      case 81:
      case 82:
        return 'Rain Showers';
      case 95:
      case 96:
      case 99:
        return 'Thunderstorm';
      default:
        return 'Moderate Weather';
    }
  }

  /// Decision Helper: Umbrella Advice
  String get umbrellaAdvice {
    if (precipitation > 0.0 || weatherCode >= 51 && weatherCode <= 99) {
      return 'Take an umbrella! 🌧️ Rain or wet conditions detected.';
    }
    return 'No umbrella needed today. Enjoy the clear skies! ☀️';
  }

  /// Decision Helper: Outdoor Activity
  String get activityAdvice {
    if (weatherCode >= 95) {
      return 'Stay indoors! ⛈️ Thunderstorm detected.';
    }
    if (precipitation > 2.0 || (weatherCode >= 61 && weatherCode <= 82)) {
      return 'Indoor activities recommended due to rainfall. ☔';
    }
    if (temperature > 35) {
      return 'Very hot! 🥵 Avoid strenuous midday outdoor sports; stay hydrated.';
    }
    if (temperature < 10) {
      return 'Chilly! 🧣 Bundle up if going outside for activities.';
    }
    return 'Great weather for outdoor sports, walking, or running! 🏃';
  }

  /// Decision Helper: Clothing Advice
  String get clothingAdvice {
    if (temperature >= 28) {
      return 'Light T-shirt, breathable clothing, sunglasses & hat.';
    } else if (temperature >= 20) {
      return 'Comfortable casual wear, short sleeves with light layer.';
    } else if (temperature >= 15) {
      return 'Light jacket or sweater recommended.';
    } else {
      return 'Warm coat, scarf, and layered clothing needed.';
    }
  }
}
