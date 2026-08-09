{------------------------------------------------------------------------------
 TopstepQuantBaseline.eld
 MultiCharts PowerLanguage signal

 Research baseline. Long/short trend + volatility expansion.
------------------------------------------------------------------------------}

Inputs:
    RiskPerTrade(125),
    RewardRisk(1.8),
    ProfitTarget(3000),
    MaxEvalLoss(2000),
    MaxDailyLoss(1000),
    MaxTradesPerDay(4),
    ATRLength(14),
    FastLength(9),
    SlowLength(30),
    VolLookback(5),
    VolExpansion(1.05),
    SessionStart(0930),
    SessionEnd(1600);

Vars:
    ATRValue(0),
    PriorATR(0),
    FastAvg(0),
    SlowAvg(0),
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
PriorATR = AvgTrueRange(ATRLength)[VolLookback];
FastAvg = AverageFC(Close, FastLength);
SlowAvg = AverageFC(Close, SlowLength);

CanTrade = Time >= SessionStart and Time <= SessionEnd
           and TradesToday < MaxTradesPerDay
           and NetProfit - DayStartNetProfit > -MaxDailyLoss
           and NetProfit > -MaxEvalLoss
           and NetProfit < ProfitTarget;

LongSignal = FastAvg > SlowAvg
             and Close > FastAvg
             and PriorATR > 0
             and ATRValue > PriorATR * VolExpansion;

ShortSignal = FastAvg < SlowAvg
              and Close < FastAvg
              and PriorATR > 0
              and ATRValue > PriorATR * VolExpansion;

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
