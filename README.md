# Trader — AI-Powered Trading Analytics

A full-stack AI-powered trading analytics platform that analyzes chart screenshots and provides structured trade plans with pattern detection, support/resistance levels, entry/exit points, market regime classification, and actionable recommendations — all powered by a vision-capable LLM (Kimi-K2.7-Code on BasTen).

![Landing Page](docs/screenshots/landing.png)

---

## Features

### AI Chart Analysis
Upload one or multiple chart screenshots (paste, drag-drop, or click), set a timeframe for each chart individually, and get instant AI analysis including:
- **3-6 patterns detected** with confidence scores and descriptions
- **Support & resistance levels** (3-6 each)
- **Entry price, stop loss, take profit** with R:R ratio
- **Market regime** classification (Trending Bullish, Trending Bearish, Ranging, Volatile, Accumulation, Distribution)
- **3-6 actionable recommendations** with categories (Entry, Risk Management, Exit, Trade Management, Confirmation)
- **Confidence score** (0-100%)
- **Market structure** analysis
- **Summary** with trade recommendation

When multiple charts are uploaded (e.g. same asset on 15m + 1h + 4h), the AI cross-references all timeframes for confluence.

![Chart Analysis](docs/screenshots/chart-analysis.png)

### Paper Trading Simulator
Practice trades with a simulated account. Open long/short positions, set SL/TP, track P&L, and close trades — all without risking real capital.

![Paper Trading](docs/screenshots/paper-trading.png)

### Trade Journal
Log every trade with direction, entry/exit prices, position size, P&L, setup type, emotion, and rating. View performance stats including win rate, profit factor, and breakdowns by day, hour, and emotion.

### Strategy Builder
Create and save trading strategies with rules, indicators, timeframe, and risk-per-trade settings.

### Signal Hub
Browse AI-generated trading signals across forex, crypto, indices, and commodities with entry/SL/TP and confidence scores.

![Signal Hub](docs/screenshots/signals.png)

### Economic Calendar
Stay ahead of market-moving events with a built-in economic calendar showing upcoming events from US, EU, UK, JP, AU, and CA with importance levels.

![Economic Calendar](docs/screenshots/calendar.png)

### Trading Academy
Learn from structured courses covering day trading fundamentals, AI-enhanced trading, risk management, advanced chart patterns, trading psychology, and strategy development.

![Academy](docs/screenshots/academy.png)

### Dashboard
Overview of recent chart analyses with quick links to all features.

![Dashboard](docs/screenshots/dashboard.png)

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Backend | FastAPI (Python) + SQLAlchemy async + SQLite |
| Frontend | Next.js 15 (TypeScript/React) + Tailwind CSS |
| AI Model | Kimi-K2.7-Code (vision-capable LLM) via BasTen API |
| Auth | JWT (HS256) + bcrypt password hashing |
| Database | SQLite (async via aiosqlite) |

---

## Getting Started

### Prerequisites
- Python 3.11+
- Node.js 18+
- npm or yarn

### Backend Setup

```bash
cd backend
pip install -r requirements.txt

# Create .env file with your AI API credentials
echo "AI_BASE_URL=https://inference.baseten.co/v1" > .env
echo "AI_API_KEY=your_baseten_api_key_here" >> .env
echo "AI_MODEL=moonshotai/Kimi-K2.7-Code" >> .env

# Start the backend
python -m uvicorn app.main:app --host 127.0.0.1 --port 8000
```

The API will be available at `http://127.0.0.1:8000`. API docs at `http://127.0.0.1:8000/docs`.

### Frontend Setup

```bash
cd frontend
npm install

# Start the dev server
npx next dev -p 3000
```

The app will be available at `http://127.0.0.1:3000`.

### Quick Start (Windows)
Double-click `start.bat` to start both servers automatically.

---

## API Endpoints

### Auth
- `POST /api/auth/signup` — Create account
- `POST /api/auth/login` — Login (returns JWT)
- `GET /api/auth/me` — Get current user

### Chart Analysis
- `POST /api/analysis/upload` — Upload chart screenshot(s) and get AI analysis
- `GET /api/analysis/history` — Get analysis history (last 50)
- `GET /api/analysis/{id}` — Get specific analysis

### Paper Trading
- `POST /api/paper-trading/` — Create trade
- `GET /api/paper-trading/` — List trades
- `POST /api/paper-trading/{id}/close` — Close trade

### Trade Journal
- `POST /api/journal/` — Create entry
- `GET /api/journal/` — List entries
- `GET /api/journal/stats` — Performance stats

### Strategies
- `POST /api/strategies/` — Create strategy
- `GET /api/strategies/` — List strategies

### Signals
- `GET /api/signals/` — List signals

### Economic Calendar
- `GET /api/calendar/` — List events

### Academy
- `GET /api/academy/` — List courses

---

## AI Analysis Output Structure

```json
{
  "symbol": "EUR/USD",
  "timeframe": "15m + 1h",
  "patterns_detected": [
    {
      "name": "Ascending Triangle",
      "confidence": 85.0,
      "description": "Bullish continuation pattern with flat resistance and rising support"
    }
  ],
  "support_levels": [100.50, 99.20, 98.80],
  "resistance_levels": [101.80, 103.50, 104.20],
  "entry_price": 100.75,
  "stop_loss": 99.50,
  "take_profit": 102.50,
  "confidence_score": 78.5,
  "risk_reward_ratio": 1.75,
  "market_structure": "Strong bullish uptrend with higher highs and higher lows",
  "market_regime": "Trending Bullish",
  "recommendations": [
    {
      "category": "Entry",
      "action": "LONG",
      "detail": "Enter long at 100.75 on breakout confirmation"
    },
    {
      "category": "Risk Management",
      "action": "Set SL",
      "detail": "Place stop loss at 99.50, risk no more than 1% of account"
    },
    {
      "category": "Exit",
      "action": "Take Profit",
      "detail": "Scale out at 101.80 and 102.50, trail stop on remainder"
    }
  ],
  "summary": "EUR/USD shows a strong bullish trend with breakout above 101.80 resistance..."
}
```

---

## Screenshot Guide

For best AI analysis results, your chart screenshot should include:

1. **Candlestick or bar chart** — OHLC candles, bars, or line from any platform (TradingView, MT4/MT5, etc.)
2. **Visible price axis** — Price labels on the right or left side so AI can read exact levels
3. **Visible time axis** — Date/time labels at the bottom for timeframe context
4. **30-50 candles** — Don't zoom too far back. Enough recent history for context, but keep candles large enough to see clearly
5. **No clutter** — Avoid too many indicators or drawings covering price action
6. **Good resolution** — Text (price labels, dates) must be readable

**How to screenshot:** `Win + Shift + S` on Windows, then `Ctrl + V` to paste directly into the upload zone.

**Multiple screenshots:** Upload the same asset on different timeframes (e.g. 15m + 1h + 4h) and set each chart's timeframe individually. The AI cross-references all charts for confluence.

---

## Project Structure

```
trader-platform/
├── backend/
│   ├── app/
│   │   ├── main.py              # FastAPI app entry point
│   │   ├── config.py           # Pydantic settings (AI config from env)
│   │   ├── schemas.py          # Pydantic request/response schemas
│   │   ├── auth/
│   │   │   └── auth.py         # JWT auth + bcrypt hashing
│   │   ├── models/
│   │   │   └── database.py     # SQLAlchemy models + async DB
│   │   ├── routers/
│   │   │   ├── auth.py          # Auth endpoints
│   │   │   ├── analysis.py      # Chart analysis endpoints
│   │   │   ├── journal.py       # Trade journal endpoints
│   │   │   ├── paper_trading.py # Paper trading endpoints
│   │   │   ├── strategies.py   # Strategy builder endpoints
│   │   │   ├── signals.py       # Signal hub endpoints
│   │   │   ├── calendar.py      # Economic calendar endpoints
│   │   │   └── academy.py      # Academy endpoints
│   │   └── services/
│   │       └── ai_analyzer.py  # Vision LLM API call + mock fallback
│   ├── requirements.txt
│   └── .env                     # AI API credentials
├── frontend/
│   ├── app/
│   │   ├── page.tsx             # Landing page
│   │   ├── login/page.tsx       # Login
│   │   ├── signup/page.tsx      # Signup
│   │   └── dashboard/
│   │       ├── layout.tsx       # Dashboard layout (sidebar + nav)
│   │       ├── page.tsx         # Dashboard overview
│   │       ├── analysis/page.tsx    # AI chart analysis
│   │       ├── paper-trading/page.tsx
│   │       ├── journal/page.tsx
│   │       ├── strategies/page.tsx
│   │       ├── signals/page.tsx
│   │       ├── calendar/page.tsx
│   │       └── academy/page.tsx
│   ├── lib/utils.ts             # API helper + utilities
│   ├── tailwind.config.js
│   └── package.json
├── docs/screenshots/            # README screenshots
├── start.bat                    # Windows quick start
└── README.md
```

---

## Test Account

A test account is available for demo purposes:
- **Email:** test@trader.com
- **Password:** test123456

---

## License

This project is for personal/educational use. Not affiliated with any commercial trading platform.
