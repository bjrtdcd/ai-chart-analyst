# Topstep $50K Quant Research

Experimental research harness for a Topstep-style evaluation. It is intentionally **not** a promise of passing or a live trading system.

## Current experiments

1. `strategy.py` — conservative trend/momentum/volatility baseline.
2. `backtest.py` — stochastic evaluation simulator with profit target, max loss and daily loss controls.
3. `research.py` — parameter sweep over risk-per-trade and win-rate assumptions.

## Next iteration

Replace the stochastic model with real 1-minute ES/MES or NQ/MNQ historical data and implement:

- session-aware entries
- opening range / VWAP / liquidity sweep features
- slippage and commissions
- news blackout windows
- walk-forward validation
- Monte Carlo trade reshuffling
- probability of reaching target before drawdown breach
- anti-overfitting parameter selection

Use paper trading before any live deployment.
