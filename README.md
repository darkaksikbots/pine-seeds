# Pine Seeds - GEX Data for TradingView

This repository contains gamma exposure (GEX) data for use with TradingView Pine Script v6 `request.seed()` function.

## Available Data

- `spy_gex.json` - SPY gamma exposure levels
- `qqq_gex.json` - QQQ gamma exposure levels
- `iwm_gex.json` - IWM gamma exposure levels
- `dia_gex.json` - DIA gamma exposure levels

## Data Structure

Each JSON file contains:
- `spot` - Current spot price
- `zero_gamma` - Zero gamma level
- `net_gex` - Net gamma exposure
- `call_walls` - Top 5 resistance levels
- `put_walls` - Top 5 support levels
- `hvl` - High volume level
- `contracts` - Number of contracts analyzed
- `oi_vintage` - Date of open interest data
- `data_quality` - Data quality indicator
- `source` - Data provider

## Usage in Pine Script

```pine
//@version=6
indicator("GEX Data", overlay=true)

// Request SPY GEX data
[spot, zero_gamma, call_wall1, put_wall1] =
    request.seed("darkaksikbots", "pine-seeds", "spy_gex.json",
        ["data.spot", "data.zero_gamma", "data.call_walls[0]", "data.put_walls[0]"])

// Plot levels
plot(zero_gamma, "Zero Gamma", color.yellow)
plot(call_wall1, "Call Wall", color.red)
plot(put_wall1, "Put Wall", color.green)
```

## Update Schedule

Data is updated 2-3 times daily:
- 9:00 AM ET
- 12:00 PM ET
- 3:00 PM ET

## Data Provider

Powered by Polygon.io Chain Snapshot API with monthly options (DTE 3-35 days).