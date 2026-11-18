import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BorderRadiusProvider(),
      child: const MyApp(),
    ),
  );
}

// ==========================================
// 1. Модель стану (ChangeNotifier)
// ==========================================
class BorderRadiusProvider extends ChangeNotifier {
  double _topLeft = 0.0;
  double _topRight = 0.0;
  double _bottomLeft = 0.0;
  double _bottomRight = 0.0;

  double get topLeft => _topLeft;
  double get topRight => _topRight;
  double get bottomLeft => _bottomLeft;
  double get bottomRight => _bottomRight;

  void setTopLeft(double value) {
    _topLeft = value;
    notifyListeners();
  }

  void setTopRight(double value) {
    _topRight = value;
    notifyListeners();
  }

  void setBottomLeft(double value) {
    _bottomLeft = value;
    notifyListeners();
  }

  void setBottomRight(double value) {
    _bottomRight = value;
    notifyListeners();
  }

  void resetAll() {
    _topLeft = 0.0;
    _topRight = 0.0;
    _bottomLeft = 0.0;
    _bottomRight = 0.0;
    notifyListeners();
  }
}

// ==========================================
// 2. Головний віджет застосунку
// ==========================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Border Radius Configurator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConfiguratorScreen(),
    );
  }
}

class ConfiguratorScreen extends StatelessWidget {
  const ConfiguratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Налаштування кутів (Provider)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          children: [
            SizedBox(height: 16),
            // Окремий кастомний віджет із синім контейнером 150x150
            BlueRoundedBox(),
            SizedBox(height: 36),
            // Окрема кастомна секція зі слайдерами
            CornerSlidersSection(),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. Кастомний віджет: Синій контейнер 150x150
// ==========================================
class BlueRoundedBox extends StatelessWidget {
  const BlueRoundedBox({super.key});

  @override
  Widget build(BuildContext context) {
    // Використовуємо Consumer, щоб перебудовувався тільки сам контейнер при зміні радіусів
    return Consumer<BorderRadiusProvider>(
      builder: (context, radiusProvider, child) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(radiusProvider.topLeft),
              topRight: Radius.circular(radiusProvider.topRight),
              bottomLeft: Radius.circular(radiusProvider.bottomLeft),
              bottomRight: Radius.circular(radiusProvider.bottomRight),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// 4. Кастомний віджет: Секція зі слайдерами
// ==========================================
class CornerSlidersSection extends StatelessWidget {
  const CornerSlidersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BorderRadiusProvider>();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Радіус заокруглення кутів',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: provider.resetAll,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Скинути'),
                ),
              ],
            ),
            const Divider(),
            _CornerSliderRow(
              label: 'Верхній лівий (TL)',
              value: provider.topLeft,
              onChanged: provider.setTopLeft,
            ),
            _CornerSliderRow(
              label: 'Верхній правий (TR)',
              value: provider.topRight,
              onChanged: provider.setTopRight,
            ),
            _CornerSliderRow(
              label: 'Нижній лівий (BL)',
              value: provider.bottomLeft,
              onChanged: provider.setBottomLeft,
            ),
            _CornerSliderRow(
              label: 'Нижній правий (BR)',
              value: provider.bottomRight,
              onChanged: provider.setBottomRight,
            ),
          ],
        ),
      ),
    );
  }
}

/// Допоміжний приватний віджет для одного рядка зі слайдером та числовим значенням
class _CornerSliderRow extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _CornerSliderRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              Text(
                '${value.toStringAsFixed(0)} px',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: value,
          min: 0.0,
          max: 75.0, // 75 px — половина від 150 px (повне коло при всіх 75)
          activeColor: Colors.blue,
          onChanged: onChanged,
        ),
      ],
    );
  }
}