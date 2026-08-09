{------------------------------------------------------------------------------
 TopstepQuantBaseline.eld
 MultiCharts PowerLanguage signal

 Higher-frequency research revision for 30-minute charts.
 The previous version required ATR expansion on every entry, which was too
 restrictive. This version uses trend + momentum/breakout confirmation.
------------------------------------------------------------------------------}

Inputs:
    RiskPerTrade(125),
    RewardRisk(1.8),
    ProfitTarget(3000),
    MaxEvalLoss(2000),
    MaxDailyLoss(1000),
    MaxTradesPerDay(4),
    FastLength(9),
    SlowLength(30),
    BreakoutLength(10),
    ATRLength(14),
    MinATRPercent(0.0008),
    SessionStart(0930),
    SessionEnd(1600);

Vars:
    ATRValue(0),
    FastAvg(0),
    SlowAvg(0),
    HighestPrior(0),
    LowestPrior(0),
    TradesToday(0),
    PrevDate(0),
    DayStartNetProfit(0),
    LongSignal(False),
    ShortSignal(False),
    CanTrade(False);

If CurrentBar = 1 Then Begin
    PrevDate = Date;
    DayStartNetProfit = NetProfit;
End;

If Date <> PrevDate Then Begin
    PrevDate = Date;
    TradesToday = 0;
    DayStartNetProfit = NetProfit;
End;

ATRValue = AvgTrueRange(ATRLength);
FastAvg = AverageFC(Close, FastLength);
SlowAvg = AverageFC(Close, SlowLength);
HighestPrior = Highest(High[1], BreakoutLength);
LowestPrior = Lowest(Low[1], BreakoutLength);

CanTrade = Time >= SessionStart and Time <= SessionEnd
           and TradesToday < MaxTradesPerDay
           and NetProfit - DayStartNetProfit > -MaxDailyLoss
           and NetProfit > -MaxEvalLoss
           and NetProfit < ProfitTarget;

{ Trend + momentum OR short-term breakout. }
LongSignal = FastAvg > SlowAvg
             and Close > FastAvg
             and (Close > Close[1] or Close > HighestPrior)
             and ATRValue > Close * MinATRPercent;

ShortSignal = FastAvg < SlowAvg
              and Close < FastAvg
              and (Close < Close[1] or Close < LowestPrior)
              and ATRValue > Close * MinATRPercent;

If MarketPosition = 0 and CanTrade Then Begin
    If LongSignal Then Begin
        Buy ("QTL") Next Bar at Market;
        TradesToday = TradesToday + 1;
    End;

    If ShortSignal Then Begin
        SellShort ("QTS") Next Bar at Market;
        TradesToday = TradesToday + 1;
    End;
End;

{ Fixed-dollar bracket exits. }
If MarketPosition = 1 Then Begin
    SetStopLoss(RiskPerTrade);
    SetProfitTarget(RiskPerTrade * RewardRisk);
End;

If MarketPosition = -1 Then Begin
    SetStopLoss(RiskPerTrade);
    SetProfitTarget(RiskPerTrade * RewardRisk);
End;

If NetProfit <= -MaxEvalLoss Then Begin
    SetExitOnClose;
End;
