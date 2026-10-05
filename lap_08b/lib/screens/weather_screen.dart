import 'package:flutter/material.dart';
import '../models/weather_models.dart';
import '../services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();

  City _selectedCity = WeatherService.presetCities.first; // Default Hanoi
  late Future<CurrentWeather> _weatherFuture;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  void _fetchWeatherData() {
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(
        _selectedCity.latitude,
        _selectedCity.longitude,
      );
    });
  }

  IconData _getWeatherIcon(int code, bool isDay) {
    if (code == 0) return isDay ? Icons.wb_sunny : Icons.nightlight_round;
    if (code <= 3) return isDay ? Icons.wb_cloudy : Icons.cloud;
    if (code <= 48) return Icons.foggy;
    if (code <= 67) return Icons.grain;
    if (code <= 77) return Icons.ac_unit;
    if (code <= 82) return Icons.umbrella;
    return Icons.thunderstorm;
  }

  Color _getWeatherColor(int code) {
    if (code == 0 || code == 1) return Colors.orange;
    if (code <= 3) return Colors.blueGrey;
    if (code <= 67) return Colors.blue;
    if (code <= 82) return Colors.indigo;
    return Colors.deepPurple;
  }

  void _showCitySearchSheet() {
    final searchController = TextEditingController();
    List<City> searchResults = WeatherService.presetCities;
    bool isSearching = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                height: 400,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_city, color: Colors.blueAccent),
                        const SizedBox(width: 8),
                        const Text(
                          'Choose or Search City',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Type city name (e.g. Da Nang, Tokyo)...',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  searchController.clear();
                                  setSheetState(() {
                                    searchResults = WeatherService.presetCities;
                                  });
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14),
                      ),
                      onChanged: (query) async {
                        setSheetState(() => isSearching = true);
                        final results = await _weatherService.searchCities(query);
                        setSheetState(() {
                          searchResults = results;
                          isSearching = false;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Cities',
                      style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: isSearching
                          ? const Center(child: CircularProgressIndicator())
                          : searchResults.isEmpty
                              ? const Center(child: Text('No cities found'))
                              : ListView.builder(
                                  itemCount: searchResults.length,
                                  itemBuilder: (context, index) {
                                    final city = searchResults[index];
                                    final isSelected = city.name == _selectedCity.name;
                                    return ListTile(
                                      leading: Icon(
                                        Icons.place,
                                        color: isSelected ? Colors.blueAccent : Colors.grey,
                                      ),
                                      title: Text(
                                        city.name,
                                        style: TextStyle(
                                          fontWeight:
                                              isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                      subtitle: Text(city.country),
                                      trailing: isSelected
                                          ? const Icon(Icons.check, color: Colors.blueAccent)
                                          : null,
                                      onTap: () {
                                        Navigator.pop(ctx);
                                        setState(() {
                                          _selectedCity = city;
                                          _fetchWeatherData();
                                        });
                                      },
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      appBar: AppBar(
        title: const Text('Weather Companion', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Weather',
            onPressed: _fetchWeatherData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _fetchWeatherData(),
        color: Colors.blue.shade700,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // City Selector Card
              InkWell(
                onTap: _showCitySearchSheet,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.redAccent, size: 28),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedCity.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            Text(
                              _selectedCity.country.isNotEmpty
                                  ? _selectedCity.country
                                  : 'Selected Region',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Change',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.blue.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Icon(Icons.arrow_drop_down, color: Colors.blueAccent),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Weather FutureBuilder
              FutureBuilder<CurrentWeather>(
                future: _weatherFuture,
                builder: (context, snapshot) {
                  // 1. Loading State
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Connecting to Open-Meteo REST API...',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 2. Error State
                  if (snapshot.hasError) {
                    return Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                          const SizedBox(height: 12),
                          const Text(
                            'Unable to load weather data',
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${snapshot.error}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _fetchWeatherData,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Try Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // 3. Success State
                  final weather = snapshot.data!;
                  final conditionColor = _getWeatherColor(weather.weatherCode);

                  return Column(
                    children: [
                      // Main Weather Hero Banner
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade700,
                              Colors.blue.shade500,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.shade300.withValues(alpha: 0.5),
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${weather.temperature.toStringAsFixed(1)}°C',
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      'Feels like ${weather.apparentTemperature.toStringAsFixed(1)}°C',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(
                                      _getWeatherIcon(weather.weatherCode, weather.isDay),
                                      size: 58,
                                      color: Colors.amberAccent,
                                    ),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        weather.conditionText,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(color: Colors.white24, height: 1),
                            const SizedBox(height: 16),
                            // Metrics Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildMetricItem(
                                  Icons.water_drop,
                                  'Humidity',
                                  '${weather.relativeHumidity}%',
                                ),
                                _buildMetricItem(
                                  Icons.air,
                                  'Wind',
                                  '${weather.windSpeed.toStringAsFixed(1)} km/h',
                                ),
                                _buildMetricItem(
                                  Icons.umbrella,
                                  'Precipitation',
                                  '${weather.precipitation} mm',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section Title: Smart Decision Advisor (Core Lab 8B feature!)
                      Row(
                        children: [
                          Icon(Icons.lightbulb_outline, color: conditionColor),
                          const SizedBox(width: 8),
                          const Text(
                            'Daily Decision Advisor',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Advice Card 1: Umbrella Check
                      _buildAdviceCard(
                        icon: Icons.beach_access,
                        iconColor: Colors.blueAccent,
                        title: 'Do I Need an Umbrella Today?',
                        content: weather.umbrellaAdvice,
                      ),

                      const SizedBox(height: 10),

                      // Advice Card 2: Outdoor Activity
                      _buildAdviceCard(
                        icon: Icons.directions_run,
                        iconColor: Colors.orangeAccent,
                        title: 'Outdoor Activities & Sports',
                        content: weather.activityAdvice,
                      ),

                      const SizedBox(height: 10),

                      // Advice Card 3: What to Wear
                      _buildAdviceCard(
                        icon: Icons.checkroom,
                        iconColor: Colors.purpleAccent,
                        title: 'What Should I Wear?',
                        content: weather.clothingAdvice,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetricItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.8)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAdviceCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
