// ==========================================
// 1. BASE FALLBACK DATA SETS
// ==========================================
const mockStocks = [
    { name: 'ASML Holding', symbol: 'ASML', price: 912.40, change: 2.46, market: 'AEX' },
    { name: 'SAP', symbol: 'SAP', price: 183.22, change: 1.18, market: 'DAX' },
    { name: 'LVMH', symbol: 'LVMH', price: 736.10, change: -0.72, market: 'CAC 40' },
    { name: 'Siemens', symbol: 'SIE', price: 178.54, change: 0.93, market: 'DAX' },
    { name: 'TotalEnergies', symbol: 'TTE', price: 58.32, change: -1.04, market: 'CAC 40' },
    { name: 'Unilever', symbol: 'ULVR', price: 44.78, change: 0.55, market: 'FTSE 100' }
];

const chartHistoricalData = {
    '1D': [905.00, 908.50, 910.10, 907.30, 912.40],
    '1M': [865.20, 880.30, 875.00, 890.10, 912.40],
    '3M': [820.00, 845.00, 860.00, 850.00, 912.40],
    '1Y': [710.00, 780.00, 830.00, 880.00, 912.40]
};

let selectedCurrency = 'EUR';
const currencyConfig = {
    EUR: { rate: 1.00, symbol: '€' },
    USD: { rate: 1.12, symbol: '$' },
    CNY: { rate: 7.82, symbol: '¥' }
};

// ==========================================
// 2. RUN MANDATORY API QUERY CHECK
// ==========================================
async function runMarketstackAPI() {
    const apiKey = 'YOUR_FREE_API_KEY'; 
    const url = `https://api.marketstack.com/v1/eod?access_key=${apiKey}&symbols=ASML,SAP`;

    try {
        let response = await fetch(url);
        if (!response.ok) throw new Error("Quota limit reached. Activating safe local demo fallback.");
        let data = await response.json();
        console.log("Live Marketstack API connection working:", data);
    } catch (err) {
        console.warn("Marketstack Notice:", err.message);
        renderTableRows(mockStocks);
    }
}

// ==========================================
// 3. TABLE RENDERING CONVERTER ENGINE
// ==========================================
function renderTableRows(stocksArray) {
    const tableBody = document.getElementById('stock-table-body');
    if (!tableBody) return; 

    tableBody.innerHTML = ''; 
    const config = currencyConfig[selectedCurrency];

    stocksArray.forEach(stock => {
        const convertedPrice = (stock.price * config.rate).toFixed(2);
        const isPositive = stock.change >= 0;
        const trendClass = isPositive ? 'text-positive' : 'text-negative';
        const trendSign = isPositive ? '+' : '';

        tableBody.innerHTML += `
            <tr>
                <td>${stock.name}</td>
                <td><strong>${stock.symbol}</strong></td>
                <td>${config.symbol}${convertedPrice}</td>
                <td class="${trendClass} fw-bold">${trendSign}${stock.change}%</td>
                <td>${stock.market}</td>
                <td><a href="stock-detail.html" class="btn-custom d-inline-block" style="padding:5px 14px; font-size:0.85rem">View</a></td>
            </tr>
        `;
    });
}

// ==========================================
// 4. INTERACTIVE BINDINGS
// ==========================================
function initSearchEngine() {
    const searchBar = document.getElementById('search-input');
    if (!searchBar) return;

    searchBar.addEventListener('input', (event) => {
        const keyword = event.target.value.toLowerCase();
        const matched = mockStocks.filter(stock => 
            stock.name.toLowerCase().includes(keyword) ||
            stock.symbol.toLowerCase().includes(keyword) ||
            stock.market.toLowerCase().includes(keyword)
        );
        renderTableRows(matched);
    });
}

function initCurrencyEngine() {
    const dropdown = document.getElementById('currency-select');
    if (!dropdown) return;

    dropdown.addEventListener('change', (event) => {
        selectedCurrency = event.target.value;
        renderTableRows(mockStocks);
    });
}

function initChartTimeRangeButtons() {
    const timeFrames = ['1D', '1M', '3M', '1Y'];
    
    timeFrames.forEach(frame => {
        const targetBtn = document.getElementById(`btn-${frame}`);
        if (!targetBtn) return;

        targetBtn.addEventListener('click', () => {
            timeFrames.forEach(f => document.getElementById(`btn-${f}`)?.classList.remove('active'));
            targetBtn.classList.add('active');

            if (window.myStockChart) {
                window.myStockChart.data.datasets[0].data = chartHistoricalData[frame];
                window.myStockChart.update();
            }
        });
    });
}

// Global Execution
document.addEventListener('DOMContentLoaded', () => {
    runMarketstackAPI();
    initSearchEngine();
    initCurrencyEngine();
    initChartTimeRangeButtons();
});
