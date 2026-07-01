import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../services/stock_api_service.dart';
import '../widgets/bottom_nav.dart';
import 'package:url_launcher/url_launcher.dart';

class StockDetailPage extends StatefulWidget {
  const StockDetailPage({super.key});

  @override
  State<StockDetailPage> createState() => _StockDetailPageState();
}

class _StockDetailPageState extends State<StockDetailPage> {
  final StockApiService _stockApiService = StockApiService();

  StockQuote? _quote;
  List<StockQuote> _history = [];

  bool _isLoading = true;
  bool _hasLoaded = false;
  String? _error;
  bool _usingFallback = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_hasLoaded) return;
    _hasLoaded = true;

    final arguments = ModalRoute.of(context)?.settings.arguments;

    if (arguments is StockQuote) {
      _quote = arguments;
      _loadHistory(arguments.symbol);
    } else {
      _isLoading = false;
      _error = 'No stock was selected.';
    }
  }

  Future<void> _loadHistory(String symbol) async {
    try {
      final history = await _stockApiService.getPriceHistory(symbol);

      if (!mounted) return;

      setState(() {
        _history = history;
        _usingFallback = false;
        _isLoading = false;
        _error = null;
      });
    } catch (e) {
      final quote = _quote;

      if (!mounted || quote == null) return;

      setState(() {
        _history = _buildFallbackHistory(quote);
        _usingFallback = true;
        _isLoading = false;
        _error = null;
      });
    }
  }

  List<StockQuote> _buildFallbackHistory(StockQuote quote) {
    final baseClose = quote.close > 0 ? quote.close : 100.0;

    final multipliers = [
      0.94,
      0.955,
      0.947,
      0.968,
      0.976,
      0.989,
      1.0,
    ];

    final now = DateTime.now();

    return List.generate(multipliers.length, (index) {
      final close = baseClose * multipliers[index];

      final open = index == 0
          ? close * 0.992
          : baseClose * multipliers[index - 1];

      return StockQuote(
        symbol: quote.symbol,
        close: close,
        open: open,
        high: close * 1.018,
        low: close * 0.982,
        date: _formatFallbackDate(
          now.subtract(
            Duration(days: multipliers.length - 1 - index),
          ),
        ),
      );
    });
  }

  String _formatFallbackDate(DateTime date) {
    final month = date.month.toString().padLeft(2, '0');
    final day = date.day.toString().padLeft(2, '0');

    return '${date.year}-$month-${day}T00:00:00+0000';
  }

  Future<void> _openWebApp() async {
    final symbol = (_quote?.symbol ?? 'AAPL').toUpperCase();

    final webAppUrl =
        'https://shs96.github.io/stock-market-final-project/'
        'stock-detail.html?symbol=${Uri.encodeComponent(symbol)}';

    final uri = Uri.parse(webAppUrl);

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the web app link.'),
        ),
      );
    }
  }

  Future<void> _openNews(String symbol) async {
    final uri = Uri.https(
      'news.google.com',
      '/search',
      {'q': '$symbol stock market news'},
    );

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the news link.'),
        ),
      );
    }
  }

  String _companyName(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'AAPL':
        return 'Apple';
      case 'MSFT':
        return 'Microsoft';
      case 'NVDA':
        return 'NVIDIA';
      default:
        return symbol;
    }
  }

  TableRow _tableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(StockQuote quote) {
    if (_history.length < 2) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Not enough history data to display a chart.',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    final chartColor = quote.isPositive
        ? const Color(0xFF22D39A)
        : const Color(0xFFFF5A76);

    final spots = List.generate(
      _history.length,
          (index) => FlSpot(
        index.toDouble(),
        _history[index].close,
      ),
    );

    final prices = _history.map((item) => item.close).toList();
    final minPrice = prices.reduce((a, b) => a < b ? a : b);
    final maxPrice = prices.reduce((a, b) => a > b ? a : b);

    final difference = (maxPrice - minPrice).abs();
    final padding = difference == 0 ? 5.0 : difference * 0.15;

    return Container(
      height: 240,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: LineChart(
        LineChartData(
          minY: minPrice - padding,
          maxY: maxPrice + padding,
          gridData: const FlGridData(show: false),
          titlesData: const FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: chartColor,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: chartColor.withOpacity(0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quote = _quote;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quote == null ? 'Stock Detail' : '${quote.symbol} Detail',
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFFFF5A76),
            ),
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            '${_companyName(quote!.symbol)} (${quote.symbol})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'Latest available market date: ${quote.date.split('T').first}',
            style: const TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF171A2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Latest Close Price',
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${quote.close.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${quote.percentChange >= 0 ? '+' : ''}${quote.percentChange.toStringAsFixed(2)}%',
                  style: TextStyle(
                    color: quote.isPositive
                        ? const Color(0xFF22D39A)
                        : const Color(0xFFFF5A76),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            'Price History (${_history.length} ${_usingFallback ? 'demo points' : 'trading days'})',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (_usingFallback)
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2B2630),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Live chart data is temporarily unavailable. Showing demo history.',
                style: TextStyle(
                  color: Color(0xFFD8B15C),
                  fontSize: 13,
                ),
              ),
            ),

          const SizedBox(height: 12),

          _buildChart(quote),

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

          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF171A2E),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Table(
              border: TableBorder.all(
                color: const Color(0xFF2A2D43),
              ),
              children: [
                _tableRow(
                  'Open',
                  '\$${quote.open.toStringAsFixed(2)}',
                ),
                _tableRow(
                  'High',
                  '\$${quote.high.toStringAsFixed(2)}',
                ),
                _tableRow(
                  'Low',
                  '\$${quote.low.toStringAsFixed(2)}',
                ),
                _tableRow(
                  'Close',
                  '\$${quote.close.toStringAsFixed(2)}',
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton.icon(
            onPressed: _openWebApp,
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Detailed Web Chart'),
          ),

          const SizedBox(height: 12),

          OutlinedButton.icon(
            onPressed: () => _openNews(quote.symbol),
            icon: const Icon(Icons.article_outlined),
            label: const Text('Read Related News'),
          ),
        ],
      ),
    );
  }
}