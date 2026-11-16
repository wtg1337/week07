import 'package:flutter/material.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '등교길 날씨 확인 앱',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const WeatherHomeScreen(),
    );
  }
}

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  bool _isRaining = true;
  bool _isLoading = false;
  bool _isError = false;
  DateTime _lastUpdated = DateTime.now();

  Future<void> _refreshWeather() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isRaining = !_isRaining;
      _lastUpdated = DateTime.now();
    });
  }

  String _formatTime(DateTime dateTime) {
    final period = dateTime.hour >= 12 ? '오후' : '오전';
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$period ${hour.toString().padLeft(2, '0')}:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아침 등교길 비 확인'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoading) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text('최신 날씨 확인 중...'),
                      ] else if (_isError) ...[
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          '강수 상태 정보를 불러올 수 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          _isRaining
                              ? Icons.umbrella_rounded
                              : Icons.wb_sunny_rounded,
                          size: 80,
                          color: _isRaining ? Colors.blue : Colors.orange,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isRaining ? '지금 밖에 비가 옵니다!' : '지금 비가 오지 않습니다',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _isRaining
                              ? '우산을 꼭 챙겨서 나가세요 ☂️'
                              : '우산 없이 가볍게 출석하세요 ☀️',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                '최신 확인 시각: ${_formatTime(_lastUpdated)}',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _refreshWeather,
                icon: const Icon(Icons.refresh),
                label: const Text('지금 상태 새로고침'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
