from __future__ import annotations

from dataclasses import replace
from .backtest import Config, monte_carlo


def grid_search():
    rows = []
    for risk in (75, 100, 125, 150, 175, 200):
        for wr in (0.48, 0.50, 0.52, 0.54, 0.56):
            cfg = replace(Config(), risk_per_trade=risk, win_rate=wr)
            stats = monte_carlo(cfg, runs=2_000, seed=1000 + risk * 10 + int(wr * 100))
            rows.append((risk, wr, stats["pass_rate"], stats["breach_rate"], stats["avg_pnl"], stats["avg_max_drawdown"]))
    return sorted(rows, key=lambda x: (x[2] - x[3], x[4]), reverse=True)


if __name__ == "__main__":
    print("risk, win_rate, pass_rate, breach_rate, avg_pnl, avg_dd")
    for row in grid_search()[:10]:
        print(*row, sep=", ")
