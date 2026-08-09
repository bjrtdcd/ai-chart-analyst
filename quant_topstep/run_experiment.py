from __future__ import annotations

from dataclasses import replace
from .backtest import Config, monte_carlo


def run():
    candidates = []
    for risk in (75, 100, 125, 150, 175):
        for rr in (1.5, 1.8, 2.0, 2.2):
            for wr in (0.50, 0.52, 0.54, 0.56):
                cfg = replace(Config(), risk_per_trade=risk, rr=rr, win_rate=wr)
                stats = monte_carlo(cfg, runs=1000, seed=risk * 100 + int(rr * 10) + int(wr * 1000))
                candidates.append((stats["pass_rate"] - stats["breach_rate"], risk, rr, wr, stats))
    candidates.sort(reverse=True, key=lambda x: x[0])
    for score, risk, rr, wr, stats in candidates[:10]:
        print(f"score={score:.3f} risk=${risk} rr={rr} wr={wr:.2f} {stats}")


if __name__ == "__main__":
    run()
