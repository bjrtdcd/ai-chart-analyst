from __future__ import annotations

from dataclasses import dataclass

@dataclass(frozen=True)
class Signal:
    side: int  # +1 long, -1 short, 0 flat
    score: float
    reason: str


def atr(high, low, close, n=14):
    tr = []
    for i in range(len(close)):
        if i == 0:
            tr.append(high[i] - low[i])
        else:
            tr.append(max(high[i]-low[i], abs(high[i]-close[i-1]), abs(low[i]-close[i-1])))
    out = [None] * len(close)
    if len(close) >= n:
        out[n-1] = sum(tr[:n]) / n
        for i in range(n, len(close)):
            out[i] = (out[i-1] * (n-1) + tr[i]) / n
    return out


def generate_signals(open_, high, low, close, volume=None):
    """Simple research baseline: trend + VWAP proxy + volatility expansion.

    This is deliberately conservative and intended as a benchmark to beat with
    walk-forward research, not as a claim of profitability.
    """
    a = atr(high, low, close)
    signals = []
    for i in range(len(close)):
        if i < 30 or a[i] is None:
            signals.append(Signal(0, 0.0, "warmup"))
            continue
        fast = sum(close[i-8:i+1]) / 9
        slow = sum(close[i-29:i+1]) / 30
        vol = a[i]
        prior_vol = a[i-5]
        expansion = prior_vol is not None and vol > prior_vol * 1.05
        if fast > slow and close[i] > fast and expansion:
            signals.append(Signal(1, 0.70, "trend + momentum + volatility expansion"))
        elif fast < slow and close[i] < fast and expansion:
            signals.append(Signal(-1, 0.70, "trend + momentum + volatility expansion"))
        else:
            signals.append(Signal(0, 0.0, "no confluence"))
    return signals
