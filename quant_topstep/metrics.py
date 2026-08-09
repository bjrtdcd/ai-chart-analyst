from __future__ import annotations

from dataclasses import dataclass

@dataclass(frozen=True)
class Trade:
    pnl: float


def summarize(trades: list[Trade]) -> dict[str, float]:
    if not trades:
        return {"trades": 0.0, "win_rate": 0.0, "profit_factor": 0.0, "expectancy": 0.0, "max_drawdown": 0.0}
    wins = [t.pnl for t in trades if t.pnl > 0]
    losses = [t.pnl for t in trades if t.pnl < 0]
    equity = peak = 0.0
    max_dd = 0.0
    for t in trades:
        equity += t.pnl
        peak = max(peak, equity)
        max_dd = max(max_dd, peak - equity)
    gross_loss = abs(sum(losses))
    return {
        "trades": float(len(trades)),
        "win_rate": len(wins) / len(trades),
        "profit_factor": sum(wins) / gross_loss if gross_loss else float("inf"),
        "expectancy": sum(t.pnl for t in trades) / len(trades),
        "max_drawdown": max_dd,
    }
