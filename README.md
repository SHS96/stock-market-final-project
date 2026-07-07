# Aster Markets

Aster Markets is a stock market tracking application built as a team final project, delivered as both a **responsive web app** and a **Flutter mobile app**, sharing the same design language and core features.

## Features

- **Market overview** — browse a live table of stocks with symbol, price, and daily change
- **Search & filter** — search by company name, symbol, market, or country
- **Currency conversion** — view prices converted to USD, EUR, or CNY
- **Live vs. demo data** — pulls end-of-day quotes from the [Marketstack API](https://marketstack.com/) when a personal API key is supplied, and falls back to built-in demo data otherwise
- **Location detection** — mobile app detects the user's country via device geolocation to tailor the market view (web app supports IP-based reverse geocoding)
- **Stock detail view** — per-stock page with a price chart across multiple time ranges (1D / 1M / 3M / 1Y)
- **Portfolio** — track holdings in a personal portfolio view
- **Login / sign-up** — basic authentication screens
- **Pro tier** — upgrade page presenting premium plan options

## Project Structure

```
stock-market-final-project/
├── web_app/          # Static web app (HTML, CSS, vanilla JS, Bootstrap 5)
│   ├── index.html        # Home
│   ├── login.html        # Sign in / sign up
│   ├── market.html        # Market overview & search
│   ├── stock-detail.html  # Stock detail + chart
│   ├── portfolio.html     # Portfolio view
│   ├── pro.html           # Pro upgrade page + project team credits
│   ├── app.js             # Core app logic (API calls, filtering, currency, charts)
│   ├── js/script.js       # Supporting UI scripting
│   └── css/style.css      # Styling
├── docs/             # Mirror of web_app/, served via GitHub Pages
├── mobile_app/
│   └── aster_markets_app/ # Flutter application
│       └── lib/
│           ├── main.dart
│           ├── pages/       # home, login, market, portfolio, stock_detail, pro
│           ├── services/    # stock_api_service.dart, location_service.dart
│           └── widgets/     # bottom_nav.dart, stock_card.dart
└── figma/            # UI/UX design mockups (Home, Market, Stock Details, Portfolio, Sign In/Up, Pro)
```

## Getting Started

### Web app

The web app has no build step — it's static HTML/CSS/JS.

1. Open `web_app/index.html` directly in a browser, **or** serve the folder locally, e.g.:
   ```bash
   cd web_app
   python3 -m http.server 8000
   ```
   Then visit `http://localhost:8000`.
2. By default the app shows demo stock data.
3. To see live data, go to the **Market** page and click **Live Data**, then enter a [Marketstack](https://marketstack.com/) API key when prompted. The key is stored only in `sessionStorage` for that browser tab.

> A live copy of the web app (from `docs/`) can also be published via GitHub Pages from the repository settings.

### Mobile app (Flutter)

Requirements: [Flutter SDK](https://docs.flutter.dev/get-started/install) (^3.9.2 environment).

1. Install dependencies:
   ```bash
   cd mobile_app/aster_markets_app
   flutter pub get
   ```
2. Run on a connected device/emulator, passing your Marketstack API key as a compile-time environment variable:
   ```bash
   flutter run --dart-define=MARKETSTACK_API_KEY=your_api_key_here
   ```
   Without a key, live quote requests will fail with a "API key is missing" error.
3. The app requests location permissions to detect the user's country (via `geolocator` / `geocoding`); it defaults to **Germany** if location is unavailable or denied.

## Tech Stack

| Layer        | Technology                                              |
|--------------|----------------------------------------------------------|
| Web frontend | HTML5, CSS3, vanilla JavaScript, Bootstrap 5              |
| Mobile app   | Flutter/Dart, `fl_chart`, `geolocator`, `geocoding`, `http`, `url_launcher` |
| Market data  | [Marketstack](https://marketstack.com/) EOD API           |
| Design       | Figma                                                    |

## Design

UI mockups for all core screens (Home, Market/News, Stock Details, Portfolio, Sign In/Up, Pro) are available as PDFs in [`figma/Stock Trading Apps and Websites`](figma/Stock%20Trading%20Apps%20and%20Websites).

## Team

| Name | Matriculation No. | Contribution |
|---|---|---|
| Haisheng Sun | 33016756 | Flutter Development & Web Integration |
| Xiaowei Li | 31703926 | Figma Design & UI Assets |
| Kritika Chaudhary | 29418304 | Responsive Web Layout & Testing |
| Basir Ahmad Mehrzad | 74089841 | API, Search, Currency & Chart Functions |

## Notes

- `market.html.backup` files under `web_app/` and `docs/` are leftover working copies and can be safely removed.
- Marketstack API keys are never committed to the repo; they're supplied at runtime (browser session storage for web, `--dart-define` for Flutter).

## License

No license specified — add one (e.g. MIT) if this project will be shared or reused publicly.
