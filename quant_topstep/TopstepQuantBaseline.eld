{------------------------------------------------------------------------------
 TopstepQuantBaseline.eld
 MultiCharts PowerLanguage signal

 Research baseline translated from quant_topstep/strategy.py.
 Logic: 9-bar fast average > 30-bar slow average + close above fast
 average + ATR volatility expansion.

 This is a research baseline, NOT a guaranteed profitable/live strategy.
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
    DayStartEquity(0),
    StartingEquity(0),
    PeakEquity(0),
    NetProfitAtDayStart(0),
    TradesToday(0),
    PrevDate(0),
    LongSignal(False),
    ShortSignal(False),
    CanTrade(False);

{ Use Strategy Performance Report equity as the account equity proxy. }
StartingEquity = 50000;

If Date <> PrevDate Then Begin
    PrevDate = Date;
    TradesToday = 0;
    NetProfitAtDayStart = NetProfit;
End;

ATRValue = AvgTrueRange(ATRLength);
PriorATR = AvgTrueRange(ATRLength)[VolLookback];
FastAvg = AverageFC(Close, FastLength);
SlowAvg = AverageFC(Close, SlowLength);

CanTrade = Time >= SessionStart and Time <= SessionEnd
           and TradesToday < MaxTradesPerDay
           and NetProfit - NetProfitAtDayStart > -MaxDailyLoss
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

{ One entry per bar; bracket exits are attached to the entry price. }
If MarketPosition = 0 and CanTrade Then Begin

    If LongSignal Then Begin
        Buy ("QTL") Next Bar at Market;
        TradesToday = TradesToday + 1;
    End

    If ShortSignal Then Begin
        SellShort ("QTS") Next Bar at Market;
        TradesToday = TradesToday + 1;
    End;
End;

{ Dollar risk is represented with fixed-dollar stops/targets per contract.
  For ES, $125 is not a whole-tick stop; MultiCharts will round to the
  instrument's minimum price increment. Adjust RiskPerTrade for the symbol. }

If MarketPosition = 1 Then Begin
    SetStopLoss(RiskPerTrade);
    SetProfitTarget(RiskPerTrade * RewardRisk);
End;

If MarketPosition = -1 Then Begin
    SetStopLoss(RiskPerTrade);
    SetProfitTarget(RiskPerTrade * RewardRisk);
End;

{ Hard evaluation guard: stop issuing new entries after the loss limit.
  The platform's account/equity settings should enforce the actual
  evaluation drawdown rule. }
If NetProfit <= -MaxEvalLoss Then Begin
    SetExitOnClose;
End;
