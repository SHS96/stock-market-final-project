import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/stock_card.dart';
import '../services/location_service.dart';
import '../services/stock_api_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _country = 'Loading...';

  final StockApiService _stockApiService = StockApiService();

  List<StockQuote> _quotes = [];
  bool _isLoadingStocks = true;
  String? _stockError;

  final Map<String, String> _companyNames = {
    'AAPL': 'Apple',
    'MSFT': 'Microsoft',
    'NVDA': 'NVIDIA',
  };

  bool _usingFallback = false;

  static const List<StockQuote> _fallbackQuotes = [
    StockQuote(
      symbol: 'AAPL',
      close: 195.32,
      open: 193.10,
      high: 196.20,
      low: 192.80,
      date: '2026-06-20T00:00:00+0000',
    ),
    StockQuote(
      symbol: 'MSFT',
      close: 420.10,
      open: 417.50,
      high: 422.40,
      low: 416.80,
      date: '2026-06-20T00:00:00+0000',
    ),
    StockQuote(
      symbol: 'NVDA',
      close: 138.25,
      open: 140.10,
      high: 141.30,
      low: 137.90,
      date: '2026-06-20T00:00:00+0000',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadCountry();
    _loadStocks();
  }

  Future<void> _loadCountry() async {
    final country = await LocationService().getCountryName();

    if (!mounted) return;

    setState(() {
      _country = country;
    });
  }

  Future<void> _loadStocks() async {
    setState(() {
      _isLoadingStocks = true;
      _stockError = null;
    });

    try {
      final quotes = await _stockApiService.getLatestQuotes([
        'AAPL',
        'MSFT',
        'NVDA',
      ]);

      if (!mounted) return;

      setState(() {
        _quotes = quotes;
        _usingFallback = false;
        _isLoadingStocks = false;
        _stockError = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _quotes = List<StockQuote>.from(_fallbackQuotes);
        _usingFallback = true;
        _isLoadingStocks = false;
        _stockError = null;
      });
    }
  }

  Widget _marketBox(String title, String value, String change, bool positive) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF171A2E),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            change,
            style: TextStyle(
              color: positive ? const Color(0xFF22D39A) : const Color(0xFFFF5A76),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          const Icon(Icons.show_chart, color: Colors.grey),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: SvgPicture.asset(
            'assets/logo_icon.svg',
            width: 28,
            height: 28,
          ),
        ),
        title: const Text('Aster Markets'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.notifications_none),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: ListView(
          children: [
            Text(
              '$_country Market Pulse',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Track market prices, news and your portfolio.',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 20),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _marketBox('DAX', '18,497.32', '+0.82%', true),
                  const SizedBox(width: 12),
                  _marketBox('FTSE 100', '8,231.14', '-0.18%', false),
                  const SizedBox(width: 12),
                  _marketBox('CAC 40', '7,992.10', '+0.41%', true),
                ],
              ),
            ),

          const SizedBox(height: 24),

          const Text(
            'Watchlist',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

            if (_isLoadingStocks)
              const Padding(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            else ...[
              if (_usingFallback)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2B2630),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Live market data is temporarily unavailable. Showing demo data.',
                    style: TextStyle(
                      color: Color(0xFFD8B15C),
                      fontSize: 13,
                    ),
                  ),
                ),

              ..._quotes.map((quote) {
                final sign = quote.percentChange >= 0 ? '+' : '';

                return StockCard(
                  name: _companyNames[quote.symbol] ?? quote.symbol,
                  symbol: quote.symbol,
                  price: '\$${quote.close.toStringAsFixed(2)}',
                  change: '$sign${quote.percentChange.toStringAsFixed(2)}%',
                  isPositive: quote.isPositive,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/stock-detail',
                      arguments: quote,
                    );
                  },
                );
              }),
            ],


          ],
        ),
      ),
    );
  }
}