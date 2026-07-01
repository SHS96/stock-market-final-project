import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/stock_card.dart';
import '../services/location_service.dart';
import '../services/stock_api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _country = 'Loading...';

  final StockApiService _stockApiService = StockApiService();

  final Uri _webAppUri = Uri.parse(
    'https://shs96.github.io/stock-market-final-project/',
  );

  Future<void> _openWebApp() async {
    final launched = await launchUrl(
      _webAppUri,
      mode: LaunchMode.externalApplication,
    );

    if (!launched && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the web app.'),
        ),
      );
    }
  }

  List<StockQuote> _quotes = [];
  bool _isLoadingStocks = true;
  String? _stockError;

  final Map<String, String> _companyNames = {
    'AAPL': 'Apple',
    'MSFT': 'Microsoft',
    'NVDA': 'NVIDIA',
    'AMZN': 'Amazon',
    'GOOGL': 'Alphabet',
    'TSLA': 'Tesla',
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
    StockQuote(
      symbol: 'AMZN',
      close: 185.60,
      open: 184.10,
      high: 187.00,
      low: 183.50,
      date: '2026-06-20T00:00:00+0000',
    ),
    StockQuote(
      symbol: 'GOOGL',
      close: 175.80,
      open: 176.90,
      high: 177.50,
      low: 174.20,
      date: '2026-06-20T00:00:00+0000',
    ),
    StockQuote(
      symbol: 'TSLA',
      close: 183.20,
      open: 181.00,
      high: 185.60,
      low: 179.80,
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
        'AMZN',
        'GOOGL',
        'TSLA',
      ]);

      if (!mounted) return;

      final quoteBySymbol = {
        for (final quote in quotes) quote.symbol.toUpperCase(): quote,
      };

      final completedQuotes = _fallbackQuotes.map((fallbackQuote) {
        return quoteBySymbol[fallbackQuote.symbol] ?? fallbackQuote;
      }).toList();

      if (!mounted) return;

      setState(() {
        _quotes = completedQuotes;
        _usingFallback = quotes.length < _fallbackQuotes.length;
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

        actions: [
          IconButton(
            tooltip: 'Open Web App',
            icon: const Icon(Icons.language),
            onPressed: _openWebApp,
          ),
          const Padding(
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
                  _marketBox('NASDAQ', 'Demo', '+0.72%', true),
                  const SizedBox(width: 12),
                  _marketBox('S&P 500', 'Demo', '+0.48%', true),
                  const SizedBox(width: 12),
                  _marketBox('Dow Jones', 'Demo', '-0.16%', false),
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
                    'Some live prices are unavailable. Demo data is shown for missing stocks.',
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