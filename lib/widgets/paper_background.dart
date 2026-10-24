// фон как лист из тетради, вродь красиво
import 'package:flutter/material.dart';

class PaperBackground extends StatelessWidget {
  final Widget child;
  const PaperBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    // CustomPaint рисует painter child, поэтому линии будут сзади,
    // а карточки и текст сверху их перекроют
    return CustomPaint(
      painter: PaperPainter(
        lineColor: s.outline.withValues(alpha: 0.10), // почти прозрачные, иначе рябит
        marginColor: s.primary.withValues(alpha: 0.25),
      ),
      child: child,
    );
  }
}

class PaperPainter extends CustomPainter {
  final Color lineColor;
  final Color marginColor;

  PaperPainter({required this.lineColor, required this.marginColor});

  @override
  void paint(Canvas canvas, Size size) {
    var linePaint = Paint();
    linePaint.color = lineColor;
    linePaint.strokeWidth = 1;

    for (double y = 28; y < size.height; y = y + 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // линия полей слева, как в тетради
    var marginPaint = Paint();
    marginPaint.color = marginColor;
    marginPaint.strokeWidth = 1.5;
    canvas.drawLine(const Offset(8, 0), Offset(8, size.height), marginPaint);
  }

  @override
  bool shouldRepaint(PaperPainter oldDelegate) => true;
}
