//
//  TradingViewChartView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 05/05/2021.
//

import Foundation


fileprivate let firstPart = """
    
    <meta name="viewport" content="width=device-width,initial-scale=1.0,maximum-scale=1.0,minimum-scale=1.0">

    <body style="background-color:rgba(18,23,34,255);">
    
    <div class="tradingview-widget-container">
      <div id="tradingview_bab73"></div>
      <div class="tradingview-widget-copyright"><a href="https://www.tradingview.com/symbols/NASDAQ-AAPL/" rel="noopener" target="_blank"><span class="blue-text">AAPL Chart</span></a> by TradingView</div>
      <script type="text/javascript" src="https://s3.tradingview.com/tv.js"></script>
      <script type="text/javascript">
      new TradingView.widget(
    """

fileprivate let secondPart = """
       );
       </script>
     </div>
     </body>
     """

enum TradingViewChartTimeInterval: CaseIterable {
    
    case minute1
    case minute3
    case minute5
    case minute15
    case minute30
    case hour1
    case hour2
    case hour3
    case hour4
    case day
    case week
    
    var description: String {
            switch self {
            case .minute1: return "1m"
            case .minute3: return "3m"
            case .minute5: return "5m"
            case .minute15: return "15m"
            case .minute30: return "30m"
            case .hour1: return "1h"
            case .hour2: return "2h"
            case .hour3: return "3h"
            case .hour4: return "4h"
            case .day: return "1d"
            case .week: return "1w"
            }
        }
    
    var tradingViewValue: String {
        switch self {
        case .minute1: return "1"
        case .minute3: return "3"
        case .minute5: return "5"
        case .minute15: return "15"
        case .minute30: return "30"
        case .hour1: return "60"
        case .hour2: return "120"
        case .hour3: return "180"
        case .hour4: return "240"
        case .day: return "D"
        case .week: return "W"
        }
    }
}

enum TradingViewChartDateRange: CaseIterable {
    
    case day
    case days5
    case month1
    case months3
    case months6
    case year
    case years5
    case all
    
    var description: String {
            switch self {
            case .day: return "1d"
            case .days5: return "5d"
            case .month1: return "1m"
            case .months3: return "3m"
            case .months6: return "6m"
            case .year: return "1y"
            case .years5: return "5y"
            case .all: return "All"
            }
    }
    
    var tradingViewValue: String {
        switch self {
        case .day: return "1D"
        case .days5: return "5D"
        case .month1: return "1M"
        case .months3: return "3M"
        case .months6: return "6M"
        case .year: return "12M"
        case .years5: return "60M"
        case .all: return "ALL"
        }
    }
}

enum TradingViewChartExchange: String {
    
    case binance = "BINANCE"
    case bitfinex = "BITFINEX"
    case coinbase = "COINBASE"
}

enum TradingViewChartTheme: String {
    
    case dark = "dark"
    case light = "light"
}

enum TadingViewChartBarStyle: CaseIterable {
    
    case bars
    case candles
    case hollowCandles
    case heikinAshi
    case line
    case area
    case renko
    case lineBreak
    case kagi
    case pointAndFigure
    
    var description: String {
            switch self {
            case .bars: return "bars"
            case .candles: return "candles"
            case .hollowCandles: return "hollow candles"
            case .heikinAshi: return "heikin ashi"
            case .line: return "line"
            case .area: return "area"
            case .renko: return "renko"
            case .lineBreak: return "line break"
            case .kagi: return "kagi"
            case .pointAndFigure: return "point and figure"
            }
    }
    
    var tradingViewValue: Int {
        switch self {
        case .bars: return 0
        case .candles: return 1
        case .hollowCandles: return 9
        case .heikinAshi: return 8
        case .line: return 2
        case .area: return 3
        case .renko: return 4
        case .lineBreak: return 7
        case .kagi: return 5
        case .pointAndFigure: return 6
        }
    }
}


class TradingViewChart {
    
    var symbol: String!
    var theme: TradingViewChartTheme!
    var exchange: TradingViewChartExchange!
    var barStyle: TadingViewChartBarStyle!
    
    init(symbol: String, exchange: TradingViewChartExchange, theme: TradingViewChartTheme, barStyle: TadingViewChartBarStyle = .line) {
        
        self.symbol = symbol
        self.theme = theme
        self.exchange = exchange
        self.barStyle = barStyle
    }

    func getMinimizedChart(with interval: TradingViewChartTimeInterval = .day) -> String {
        
        return getChartString(with: interval, hideLegend: true)
    }
    
    func getMinimizedChart(with range: TradingViewChartDateRange = .day) -> String {
        
        return getChartString(with: range, hideLegend: true)
    }
    
    func getFullChart(with interval: TradingViewChartTimeInterval = .day) -> String {
        
        return getChartString(with: interval, hideLegend: false)
    }
    
    func getFullChart(with range: TradingViewChartDateRange = .day) -> String {
        
        return getChartString(with: range, hideLegend: false)
    }
    
    func getChartString(with range: TradingViewChartDateRange, hideLegend: Bool) -> String {
        let params = ["autosize":true, "symbol":self.exchange.rawValue + ":" + self.symbol, "range":range.tradingViewValue, "timezone":"Etc/UTC", "theme":self.theme.rawValue, "style":self.barStyle.tradingViewValue, "local":"en", "toolbar_bg":"#f1f3f6", "enable_publishing":false, "withdateranges": false, "hide_legend":hideLegend, "hide_top_toolbar": true, "save_image":false, "container_id": "tradingview_bab73",
                      "studies":[]] as [String : Any]
        do {
            let json = try params.toJson()
            return firstPart + json + secondPart
        } catch {
            print(#function, ": Error getting trading view chart string")
            return ""
        }
    }
    
    func getChartString(with interval: TradingViewChartTimeInterval, hideLegend: Bool) -> String {
        let params = ["autosize":true, "symbol":self.exchange.rawValue + ":" + self.symbol, "interval":interval.tradingViewValue, "timezone":"Etc/UTC", "theme":self.theme.rawValue, "style":self.barStyle.tradingViewValue, "local":"en", "toolbar_bg":"#f1f3f6", "enable_publishing":false, "withdateranges": false, "hide_legend":hideLegend, "hide_top_toolbar": true, "save_image":false, "container_id": "tradingview_bab73",
                      "studies":[]] as [String : Any]
        do {
            let json = try params.toJson()
            return firstPart + json + secondPart
        } catch {
            print(#function, ": Error getting trading view chart string")
            return ""
        }
    }
    
}


extension Dictionary {
    
    /// Convert Dictionary to JSON string
    /// - Throws: exception if dictionary cannot be converted to JSON data or when data cannot be converted to UTF8 string
    /// - Returns: JSON string
    func toJson() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self)
        if let string = String(data: data, encoding: .utf8) {
            return string
        }
        throw NSError(domain: "Dictionary", code: 1, userInfo: ["message": "Data cannot be converted to .utf8 string"])
    }
}


