// ==========================================
// 1. DEMO / FALLBACK DATA
// ==========================================

const mockStocks = [
  {
    name: "Apple",
    symbol: "AAPL",
    price: 195.32,
    change: 1.15,
    country: "United States",
    market: "NASDAQ",
  },
  {
    name: "Microsoft",
    symbol: "MSFT",
    price: 420.10,
    change: 0.62,
    country: "United States",
    market: "NASDAQ",
  },
  {
    name: "NVIDIA",
    symbol: "NVDA",
    price: 138.25,
    change: -1.32,
    country: "United States",
    market: "NASDAQ",
  },
  {
    name: "Amazon",
    symbol: "AMZN",
    price: 185.60,
    change: 0.81,
    country: "United States",
    market: "NASDAQ",
  },
  {
    name: "Alphabet",
    symbol: "GOOGL",
    price: 175.80,
    change: -0.62,
    country: "United States",
    market: "NASDAQ",
  },
  {
    name: "Tesla",
    symbol: "TSLA",
    price: 183.20,
    change: 1.22,
    country: "United States",
    market: "NASDAQ",
  },
];
  


let currentStocks = [...mockStocks];
let selectedCurrency = "USD";


const currencyConfig = {
  USD: { rate: 1.0, symbol: "$" },
  EUR: { rate: 0.92, symbol: "€" },
  CNY: { rate: 7.2, symbol: "¥" },
};


// Only used when testing the live API.
const apiSymbols = ["AAPL", "MSFT", "NVDA", "AMZN", "GOOGL", "TSLA"];

const stockMeta = {
  AAPL: { name: "Apple", country: "United States" },
  MSFT: { name: "Microsoft", country: "United States" },
  NVDA: { name: "NVIDIA", country: "United States" },
  AMZN: { name: "Amazon", country: "United States" },
  GOOGL: { name: "Alphabet", country: "United States" },
  TSLA: { name: "Tesla", country: "United States" },
};

// ==========================================
// 2. CHART DATA
// ==========================================

const chartHistoricalData = {
  "1D": {
    labels: ["09:30", "11:00", "12:30", "14:00", "Close"],
    values: [905.0, 908.5, 910.1, 907.3, 912.4],
  },
  "1M": {
    labels: ["Week 1", "Week 2", "Week 3", "Week 4", "Today"],
    values: [865.2, 880.3, 875.0, 890.1, 912.4],
  },
  "3M": {
    labels: ["Month 1", "Month 2", "Month 3", "Month 4", "Today"],
    values: [820.0, 845.0, 860.0, 850.0, 912.4],
  },
  "1Y": {
    labels: ["Jul", "Sep", "Nov", "Feb", "Today"],
    values: [710.0, 780.0, 830.0, 880.0, 912.4],
  },
};

// ==========================================
// 3. HELPERS
// ==========================================

function setApiStatus(message, type = "secondary") {
  const statusBox = document.getElementById("api-status");

  if (!statusBox) return;

  statusBox.className = `alert alert-${type} py-2 mb-3`;
  statusBox.textContent = message;
}

function renderTableRows(stocksArray) {
  const tableBody = document.getElementById("stock-table-body");

  if (!tableBody) return;

  const config = currencyConfig[selectedCurrency];
  tableBody.innerHTML = "";

  stocksArray.forEach((stock) => {
    const convertedPrice = (stock.price * config.rate).toFixed(2);
    const isPositive = stock.change >= 0;
    const trendClass = isPositive ? "text-positive" : "text-negative";
    const trendSign = isPositive ? "+" : "";

    tableBody.innerHTML += `
      <tr>
        <td>${stock.name}</td>
        <td><strong>${stock.symbol}</strong></td>
        <td>${config.symbol}${convertedPrice}</td>
        <td class="${trendClass} fw-bold">
          ${trendSign}${stock.change.toFixed(2)}%
        </td>
        <td>${stock.country}</td>
        <td>${stock.market}</td>
        <td>
        <a href="stock-detail.html?symbol=${encodeURIComponent(stock.symbol)}"
            class="btn-custom d-inline-block"
            style="padding:5px 14px; font-size:0.85rem">
            View
        </a>
        </td>
      </tr>
    `;
  });

  if (stocksArray.length === 0) {
    tableBody.innerHTML = `
      <tr>
        <td colspan="7" class="text-center text-muted">
          No matching stocks found.
        </td>
      </tr>
    `;
  }
}

function applyFilters() {
  const searchInput = document.getElementById("search-input");
  const keyword = searchInput ? searchInput.value.trim().toLowerCase() : "";

  const filteredStocks = currentStocks.filter((stock) => {
    return (
      stock.name.toLowerCase().includes(keyword) ||
      stock.symbol.toLowerCase().includes(keyword) ||
      stock.country.toLowerCase().includes(keyword) ||
      stock.market.toLowerCase().includes(keyword)
    );
  });

  renderTableRows(filteredStocks);
}

// ==========================================
// 4. MARKETSTACK API
// ==========================================

function convertMarketstackData(payload) {
  const rows = Array.isArray(payload?.data) ? payload.data : [];
  const latestBySymbol = new Map();

  rows.forEach((row) => {
    const symbol = String(row.symbol || "").toUpperCase();

    if (!symbol) return;

    const oldRow = latestBySymbol.get(symbol);

    if (
      !oldRow ||
      new Date(row.date).getTime() > new Date(oldRow.date).getTime()
    ) {
      latestBySymbol.set(symbol, row);
    }
  });

  return apiSymbols
    .map((symbol) => {
      const row = latestBySymbol.get(symbol);

      if (!row) return null;

      const close = Number(row.close);
      const open = Number(row.open);

      if (!Number.isFinite(close) || close <= 0) return null;

      const change =
        Number.isFinite(open) && open > 0
          ? ((close - open) / open) * 100
          : 0;

      const meta = stockMeta[symbol] || {
        name: symbol,
        country: "Unknown",
      };

      return {
        name: meta.name,
        symbol: symbol,
        price: close,
        change: change,
        country: meta.country,
        market: row.exchange || "Marketstack",
      };
    })
    .filter(Boolean);
}

async function loadLiveMarketData() {
  const apiKey = sessionStorage.getItem("MARKETSTACK_API_KEY");

  if (!apiKey) {
    currentStocks = [...mockStocks];
    applyFilters();
    setApiStatus("Demo data is currently displayed.", "secondary");
    return;
  }

  setApiStatus("Loading Marketstack end-of-day data...", "info");

  try {
    const params = new URLSearchParams({
        access_key: apiKey,
        symbols: apiSymbols.join(","),
        limit: "20",
    });

    const response = await fetch(
        `https://api.marketstack.com/v1/eod?${params.toString()}`
    );

    const payload = await response.json().catch(() => ({}));

    if (!response.ok || payload.error) {
      throw new Error(
        payload?.error?.message ||
          `API request failed with status ${response.status}`
      );
    }

    const liveStocks = convertMarketstackData(payload);

    if (liveStocks.length === 0) {
      throw new Error("No usable stock data was returned.");
    }

    currentStocks = liveStocks;
    applyFilters();

    setApiStatus(
      "Live Marketstack end-of-day data loaded successfully.",
      "success"
    );
  } catch (error) {
    console.warn("Marketstack error:", error.message);

    currentStocks = [...mockStocks];
    applyFilters();

    setApiStatus(
      `Live data is unavailable. Demo data is displayed instead. ${error.message}`,
      "warning"
    );
  }
}

// ==========================================
// 5. EVENTS
// ==========================================

function initSearchEngine() {
  const searchInput = document.getElementById("search-input");

  if (!searchInput) return;

  searchInput.addEventListener("input", applyFilters);
}

function initCurrencyEngine() {
  const currencySelect = document.getElementById("currency-select");

  if (!currencySelect) return;

  currencySelect.addEventListener("change", (event) => {
    selectedCurrency = event.target.value;
    applyFilters();
  });
}

function initLiveDataButtons() {
  const liveButton = document.getElementById("live-data-button");
  const demoButton = document.getElementById("demo-data-button");

  liveButton?.addEventListener("click", () => {
    const apiKey = window.prompt(
      "Enter your Marketstack API key. It will only be stored for this browser session."
    );

    if (!apiKey || !apiKey.trim()) return;

    sessionStorage.setItem("MARKETSTACK_API_KEY", apiKey.trim());
    loadLiveMarketData();
  });

  demoButton?.addEventListener("click", () => {
    sessionStorage.removeItem("MARKETSTACK_API_KEY");
    currentStocks = [...mockStocks];
    applyFilters();
    setApiStatus("Demo data is currently displayed.", "secondary");
  });
}

function initChartTimeRangeButtons() {
  const timeFrames = ["1D", "1M", "3M", "1Y"];

  timeFrames.forEach((frame) => {
    const button = document.getElementById(`btn-${frame}`);

    if (!button) return;

    button.addEventListener("click", () => {
      timeFrames.forEach((item) => {
        document.getElementById(`btn-${item}`)?.classList.remove("active");
      });

      button.classList.add("active");

      const selectedData = chartHistoricalData[frame];

      if (window.myStockChart && selectedData) {
        window.myStockChart.data.labels = selectedData.labels;
        window.myStockChart.data.datasets[0].data = selectedData.values;
        window.myStockChart.update();
      }
    });
  });
}

// ==========================================
// 6. START
// ==========================================

document.addEventListener("DOMContentLoaded", () => {
  const marketTable = document.getElementById("stock-table-body");

  // API only runs on Market page.
  if (marketTable) {
    initSearchEngine();
    initCurrencyEngine();
    initLiveDataButtons();
    renderTableRows(currentStocks);
    setApiStatus("Demo data is currently displayed.", "secondary");
  }

  initChartTimeRangeButtons();
});


// ==========================================
// COUNTRY MARKET SELECTOR AND GEOLOCATION
// ==========================================

let selectedMarketCountry = "United States";

const countryMarketConfig = {
  "United States": {
    index: "NASDAQ",
    description: "US technology market overview is selected.",
  },
  Germany: {
    index: "DAX",
    description: "German market overview is selected.",
  },
  France: {
    index: "CAC 40",
    description: "French market overview is selected.",
  },
  Netherlands: {
    index: "AEX",
    description: "Netherlands market overview is selected.",
  },
  "United Kingdom": {
    index: "FTSE 100",
    description: "United Kingdom market overview is selected.",
  },
};

function setLocationStatus(message, type = "secondary") {
  const statusBox = document.getElementById("location-status");

  if (!statusBox) return;

  statusBox.className = `alert alert-${type} py-2 mb-2`;
  statusBox.textContent = message;
}

function updateMarketCountryUI() {
  const config =
    countryMarketConfig[selectedMarketCountry] ||
    countryMarketConfig["United States"];

  const label = document.getElementById("selected-country-label");
  const context = document.getElementById("market-context");
  const selector = document.getElementById("country-market-select");

  if (label) {
    label.textContent = selectedMarketCountry;
  }

  if (context) {
    context.textContent = `${config.index} selected. ${config.description}`;
  }

  if (selector) {
    selector.value = selectedMarketCountry;
  }
}

function selectMarketCountry(country, source = "manual") {
  if (!countryMarketConfig[country]) {
    setLocationStatus(
      `Location detected: ${country}. Please choose a supported market manually.`,
      "warning"
    );
    return;
  }

  selectedMarketCountry = country;
  updateMarketCountryUI();

  const config = countryMarketConfig[country];
  const sourceText =
    source === "location" ? "Location detected" : "Market selected";

  setLocationStatus(
    `${sourceText}: ${country} (${config.index}).`,
    "success"
  );
}

async function getCountryFromCoordinates(latitude, longitude) {
  const url = new URL(
    "https://api.bigdatacloud.net/data/reverse-geocode-client"
  );

  url.search = new URLSearchParams({
    latitude: latitude,
    longitude: longitude,
    localityLanguage: "en",
  });

  const response = await fetch(url);

  if (!response.ok) {
    throw new Error("Reverse geocoding request failed.");
  }

  const data = await response.json();

  if (!data.countryName) {
    throw new Error("Country name was not returned.");
  }

  return data.countryName;
}

function detectMarketFromLocation() {
  if (!navigator.geolocation) {
    setLocationStatus(
      "Geolocation is not supported. Please select a country manually.",
      "warning"
    );
    return;
  }

  setLocationStatus("Requesting your location permission...", "info");

  navigator.geolocation.getCurrentPosition(
    async (position) => {
      try {
        const country = await getCountryFromCoordinates(
          position.coords.latitude,
          position.coords.longitude
        );

        selectMarketCountry(country, "location");
      } catch (_) {
        setLocationStatus(
          "Location was found, but the country could not be identified. Please select a market manually.",
          "warning"
        );
      }
    },
    () => {
      setLocationStatus(
        "Location permission was not granted. Please select a country manually.",
        "warning"
      );
    },
    {
      enableHighAccuracy: false,
      timeout: 10000,
      maximumAge: 300000,
    }
  );
}

function initCountryMarketSelector() {
  const selector = document.getElementById("country-market-select");
  const locationButton = document.getElementById("detect-location-button");

  if (!selector) return;

  selector.addEventListener("change", (event) => {
    selectMarketCountry(event.target.value);
  });

  locationButton?.addEventListener("click", detectMarketFromLocation);

  updateMarketCountryUI();

  setLocationStatus(
    "Choose a country manually or use your current location.",
    "secondary"
  );
}

document.addEventListener("DOMContentLoaded", () => {
  initCountryMarketSelector();
});

