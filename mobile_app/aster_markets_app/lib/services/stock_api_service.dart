import 'dart:convert';
import 'package:http/http.dart' as http;

class StockQuote {
  final String symbol;
  final double close;
  final double open;
  final double high;
  final double low;
  final String date;

  const StockQuote({
    required this.symbol,
    required this.close,
    required this.open,
    required this.high,
    required this.low,
    required this.date,
  });

  double get change => close - open;

  double get percentChange {
    if (open == 0) return 0;
    return (change / open) * 100;
  }

  bool get isPositive => change >= 0;

  factory StockQuote.fromMarketstack(Map<String, dynamic> json) {
    double readNumber(dynamic value) {
      if (value is num) return value.toDouble();
      return double.tryParse(value?.toString() ?? '') ?? 0.0;
    }

    return StockQuote(
      symbol: json['symbol']?.toString() ?? 'Unknown',
      close: readNumber(json['close']),
      open: readNumber(json['open']),
      high: readNumber(json['high']),
      low: readNumber(json['low']),
      date: json['date']?.toString() ?? '',
    );
  }
}

class StockApiService {
  static const String _apiKey =
  String.fromEnvironment('MARKETSTACK_API_KEY');

  Future<List<StockQuote>> getLatestQuotes(List<String> symbols) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'API key is missing. Run with MARKETSTACK_API_KEY.',
      );
    }

    final uri = Uri.https(
      'api.marketstack.com',
      '/v2/eod/latest',
      {
        'access_key': _apiKey,
        'symbols': symbols.join(','),
      },
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception('Marketstack request failed: ${response.statusCode}');
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid response from Marketstack.');
    }

    if (decoded['error'] != null) {
      final error = decoded['error'];

      if (error is Map && error['message'] != null) {
        throw Exception(error['message'].toString());
      }

      throw Exception('Marketstack returned an API error.');
    }

    final rawData = decoded['data'];

    if (rawData is! List || rawData.isEmpty) {
      throw Exception('No stock data was returned.');
    }

    final quotes = rawData
        .whereType<Map>()
        .map(
          (item) => StockQuote.fromMarketstack(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();

    final quoteBySymbol = {
      for (final quote in quotes) quote.symbol.toUpperCase(): quote,
    };

    return symbols
        .map((symbol) => quoteBySymbol[symbol.toUpperCase()])
        .whereType<StockQuote>()
        .toList();
  }

  Future<List<StockQuote>> getPriceHistory(String symbol) async {
    if (_apiKey.isEmpty) {
      throw Exception(
        'API key is missing. Run with MARKETSTACK_API_KEY.',
      );
    }

    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 14));

    final uri = Uri.https(
      'api.marketstack.com',
      '/v2/eod',
      {
        'access_key': _apiKey,
        'symbols': symbol,
        'date_from': _formatDate(startDate),
        'date_to': _formatDate(now),
        'limit': '14',
      },
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 15),
    );

    final decoded = jsonDecode(response.body);

    if (response.statusCode != 200) {
      String message = response.body;

      if (decoded is Map<String, dynamic>) {
        final error = decoded['error'];

        if (error is Map && error['message'] != null) {
          message = error['message'].toString();
        }
      }

      throw Exception(
        'Marketstack request failed (${response.statusCode}): $message',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw Exception('Invalid history response from Marketstack.');
    }

    if (decoded['error'] != null) {
      throw Exception(decoded['error'].toString());
    }

    final rawData = decoded['data'];

    if (rawData is! List || rawData.isEmpty) {
      throw Exception('No historical stock data was returned.');
    }

    final history = rawData
        .whereType<Map>()
        .map(
          (item) => StockQuote.fromMarketstack(
        Map<String, dynamic>.from(item),
      ),
    )
        .toList();

    // Put the oldest day first so the chart goes from left to right.
    history.sort((a, b) => a.date.compareTo(b.date));

    return history;
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');

    return '${date.year}-${twoDigits(date.month)}-${twoDigits(date.day)}';
  }
}