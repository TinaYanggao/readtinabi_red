import 'package:flutter/material.dart';
import 'weather_service.dart';
import 'weather_model.dart';

class WeatherScreen extends StatefulWidget {
  final String city;
  const WeatherScreen({super.key, this.city = "Bamban"});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<Weather> _weatherFuture;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.city;
    _weatherFuture = _weatherService.fetchWeather(widget.city);
  }

  void _searchWeather() {
    final city = _controller.text.trim();
    if (city.isEmpty) return;
    setState(() {
      _weatherFuture = _weatherService.fetchWeather(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1C1C1E), Color(0xFF121212)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<Weather>(
            future: _weatherFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFB71C1C)),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    "Error:\n${snapshot.error}",
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text("No weather data found",
                      style: TextStyle(color: Colors.white)),
                );
              }

              final weather = snapshot.data!;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // ===== Search Bar =====
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1C1C1E).withOpacity(0.8),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4))
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              style: const TextStyle(color: Colors.white),
                              textInputAction: TextInputAction.search,
                              onSubmitted: (_) => _searchWeather(),
                              decoration: const InputDecoration(
                                hintText: "Enter city name",
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, color: Color(0xFFB71C1C)),
                            onPressed: _searchWeather,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== Main Weather Card =====
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1C1C1E).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.35),
                                blurRadius: 12,
                                offset: const Offset(0, 6))
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weather.cityName,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 12),
                            Image.network(
                              'https://openweathermap.org/img/wn/${weather.icon}@4x.png',
                              width: 120,
                              height: 120,
                              errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.wb_cloudy, size: 100, color: Colors.white),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              "${weather.temperature.toStringAsFixed(1)}°C",
                              style: const TextStyle(
                                  color: Color(0xFFB71C1C),
                                  fontSize: 56,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              weather.description.toUpperCase(),
                              style: const TextStyle(color: Colors.white70, fontSize: 18),
                            ),

                            const SizedBox(height: 24),

                            // ===== Today & 10-Day Forecast =====
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _forecastSmall(weather.icon, "Today", weather.temperature.toStringAsFixed(0)),
                                _forecastSmall(weather.icon, "+3h", "—"),
                                _forecastSmall(weather.icon, "+6h", "—"),
                                _forecastSmall(weather.icon, "+9h", "—"),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // ===== 24-Hour Forecast Line =====
                            Container(
                              height: 60,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1C1C1E).withOpacity(0.6),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text("${weather.temperature.toStringAsFixed(0)}°",
                                      style: const TextStyle(color: Colors.white)),
                                  Text("${weather.temperature.toStringAsFixed(0)}°",
                                      style: const TextStyle(color: Colors.white)),
                                  Text("${weather.temperature.toStringAsFixed(0)}°",
                                      style: const TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _forecastSmall(String icon, String label, String temp) {
    return Column(
      children: [
        Image.network(
          'https://openweathermap.org/img/wn/$icon.png',
          width: 36,
          height: 36,
          errorBuilder: (context, error, stackTrace) =>
          const Icon(Icons.wb_cloudy, color: Colors.white70, size: 28),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        Text(temp, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
