import 'package:flutter/material.dart';

class StockDetailPage extends StatelessWidget {
  const StockDetailPage({super.key});

  Widget _infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _fakeChart() {
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2E),
        borderRadius: BorderRadius.circular(20),
      ),
      child: CustomPaint(
        painter: SimpleLineChartPainter(),
        child: const SizedBox.expand(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Detail'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            const Text(
              'ASML Holding',
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              '€912.40  +2.46%',
              style: TextStyle(
                color: Color(0xFFFF5A76),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              children: [
                Expanded(child: _infoBox('Open', '€890.10')),
                const SizedBox(width: 10),
                Expanded(child: _infoBox('High', '€918.60')),
                const SizedBox(width: 10),
                Expanded(child: _infoBox('Low', '€875.20')),
              ],
            ),

            const SizedBox(height: 20),

            const Text(
              'Price Chart',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            _fakeChart(),

            const SizedBox(height: 24),

            const Text(
              'Key Information',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            DataTable(
              headingRowColor:
              MaterialStateProperty.all(const Color(0xFF171A2E)),
              dataRowColor:
              MaterialStateProperty.all(const Color(0xFF101325)),
              columns: const [
                DataColumn(
                  label: Text('Item', style: TextStyle(color: Colors.white)),
                ),
                DataColumn(
                  label: Text('Value', style: TextStyle(color: Colors.white)),
                ),
              ],
              rows: const [
                DataRow(cells: [
                  DataCell(Text('Exchange', style: TextStyle(color: Colors.grey))),
                  DataCell(Text('AMS', style: TextStyle(color: Colors.white))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Market Cap', style: TextStyle(color: Colors.grey))),
                  DataCell(Text('€358.1B', style: TextStyle(color: Colors.white))),
                ]),
                DataRow(cells: [
                  DataCell(Text('Sector', style: TextStyle(color: Colors.grey))),
                  DataCell(Text('Technology', style: TextStyle(color: Colors.white))),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SimpleLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1177FF)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height * 0.75);
    path.lineTo(size.width * 0.15, size.height * 0.60);
    path.lineTo(size.width * 0.30, size.height * 0.66);
    path.lineTo(size.width * 0.45, size.height * 0.45);
    path.lineTo(size.width * 0.60, size.height * 0.52);
    path.lineTo(size.width * 0.75, size.height * 0.30);
    path.lineTo(size.width, size.height * 0.20);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}