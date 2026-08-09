from __future__ import annotations

from dataclasses import dataclass
from math import sqrt
import random

@dataclass(frozen=True)
class Config:
    starting_balance: float = 50_000
    profit_target: float = 3_000
    max_loss: float = 2_000
    daily_loss: float = 1_000
    risk_per_trade: float = 150
    max_trades_day: int = 4
    rr: float = 1.8
    win_rate: float = 0.52
    trading_days: int = 30

@dataclass
class Result:
    passed: bool
    breached: bool
    pnl: float
    max_drawdown: float
    trades: int
    days: int


def simulate(cfg: Config, seed: int | None = None) -> Result:
    rng = random.Random(seed)
    balance = cfg.starting_balance
    peak = balance
    max_dd = 0.0
    trades = 0

    for day in range(cfg.trading_days):
        day_start = balance
        for _ in range(cfg.max_trades_day):
            # Stop trading for the day after the daily loss budget is exhausted.
            day_pnl = balance - day_start
            if day_pnl <= -cfg.daily_loss or balance - cfg.starting_balance <= -cfg.max_loss:
                break
            win = rng.random() < cfg.win_rate
            balance += cfg.risk_per_trade * (cfg.rr if win else -1.0)
            trades += 1
            peak = max(peak, balance)
            max_dd = max(max_dd, peak - balance)
            if balance >= cfg.starting_balance + cfg.profit_target:
                return Result(True, False, balance-cfg.starting_balance, max_dd, trades, day+1)
            if balance <= cfg.starting_balance - cfg.max_loss:
                return Result(False, True, balance-cfg.starting_balance, max_dd, trades, day+1)

    return Result(False, balance <= cfg.starting_balance-cfg.max_loss,
                  balance-cfg.starting_balance, max_dd, trades, cfg.trading_days)


def monte_carlo(cfg: Config, runs: int = 10_000, seed: int = 7) -> dict[str, float]:
    results = [simulate(cfg, seed + i) for i in range(runs)]
    pass_rate = sum(r.passed for r in results) / runs
    breach_rate = sum(r.breached for r in results) / runs
    avg_pnl = sum(r.pnl for r in results) / runs
    avg_dd = sum(r.max_drawdown for r in results) / runs
    return {
        "runs": float(runs),
        "pass_rate": pass_rate,
        "breach_rate": breach_rate,
        "avg_pnl": avg_pnl,
        "avg_max_drawdown": avg_dd,
    }


if __name__ == "__main__":
    cfg = Config()
    print(monte_carlo(cfg))
