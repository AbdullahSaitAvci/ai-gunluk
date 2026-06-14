import 'package:flutter/material.dart';

/// Mood'a göre takvim/geçmiş kartlarında gösterilen küçük gradyan banner.
/// Stock resim yerine, uygulama içinde gömülü basit vektörel illüstrasyonlar.
class MoodBanner extends StatelessWidget {
  final String mood;

  const MoodBanner({super.key, required this.mood});

  @override
  Widget build(BuildContext context) {
    final visual = _visuals[mood] ?? _visuals['😊']!;

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 72,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: visual.colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: visual.decorations,
        ),
      ),
    );
  }
}

class _MoodVisual {
  final List<Color> colors;
  final List<Widget> decorations;

  const _MoodVisual({required this.colors, required this.decorations});
}

final Map<String, _MoodVisual> _visuals = {
  // 🤩 Çok mutlu — renkli gün batımı
  '🤩': _MoodVisual(
    colors: const [Color(0xFFFF9966), Color(0xFFC74B7C), Color(0xFF5E3B8B)],
    decorations: [
      Positioned(
        right: 24,
        top: 14,
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFE08A)),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(height: 26, color: Colors.black.withOpacity(0.18)),
      ),
    ],
  ),

  // 😊 Mutlu — huzurlu doğa
  '😊': _MoodVisual(
    colors: const [Color(0xFF274472), Color(0xFF7FB685)],
    decorations: [
      Positioned(
        left: 28,
        top: 12,
        child: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFFD699)),
        ),
      ),
      Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Container(height: 30, color: const Color(0xFF1F3D2E).withOpacity(0.55)),
      ),
    ],
  ),

  // 😢 Hüzünlü — yağmurlu/bulutlu
  '😢': _MoodVisual(
    colors: const [Color(0xFF3A4A5C), Color(0xFF5C7080)],
    decorations: [
      Positioned(
        left: 20,
        top: 10,
        child: Container(
          width: 60,
          height: 22,
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
        ),
      ),
      ..._rainDrops(),
    ],
  ),

  // 😠 Kızgın — fırtına
  '😠': _MoodVisual(
    colors: const [Color(0xFF4A1F1F), Color(0xFF8B3A2E)],
    decorations: [
      Positioned(
        right: 30,
        top: 8,
        child: Container(
          width: 70,
          height: 26,
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.30), borderRadius: BorderRadius.circular(20)),
        ),
      ),
      Positioned(
        left: 60,
        top: 6,
        bottom: 6,
        child: CustomPaint(size: const Size(20, 60), painter: _LightningPainter()),
      ),
    ],
  ),

  // 😴 Uykulu — gece, ay ve yıldızlar
  '😴': _MoodVisual(
    colors: const [Color(0xFF0D1B2A), Color(0xFF1B2A4A)],
    decorations: [
      Positioned(
        right: 26,
        top: 12,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFE8E4D8)),
        ),
      ),
      ..._stars(),
    ],
  ),
};

List<Widget> _rainDrops() {
  const positions = [20.0, 50.0, 80.0, 110.0, 140.0, 170.0, 200.0, 230.0, 260.0];
  return positions
      .map((x) => Positioned(
            left: x,
            top: 38,
            child: Container(
              width: 2,
              height: 16,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.35), borderRadius: BorderRadius.circular(2)),
            ),
          ))
      .toList();
}

List<Widget> _stars() {
  const positions = [
    Offset(24, 14),
    Offset(50, 30),
    Offset(90, 16),
    Offset(140, 38),
    Offset(180, 18),
    Offset(220, 32),
    Offset(260, 14),
  ];
  return positions
      .map((o) => Positioned(
            left: o.dx,
            top: o.dy,
            child: Container(
              width: 3,
              height: 3,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
            ),
          ))
      .toList();
}

class _LightningPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFE066)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width * 0.6, 0)
      ..lineTo(size.width * 0.2, size.height * 0.5)
      ..lineTo(size.width * 0.45, size.height * 0.5)
      ..lineTo(size.width * 0.1, size.height)
      ..lineTo(size.width * 0.8, size.height * 0.45)
      ..lineTo(size.width * 0.5, size.height * 0.45)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
