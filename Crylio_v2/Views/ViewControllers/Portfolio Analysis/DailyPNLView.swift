//
//  DailyPNLView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 22/06/2021.
//

import Foundation
import UIKit
import Charts


class DailyPNLView: BackgroundBoxWithTitleView {
    
    lazy var chartView = BarChartView()
    
    let days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
    let PNLs: [Double] = [6, 8, -26, 30, -8, 10, 13]
    
    override func commonInit() {
        super.commonInit()
        
        titleLabel.text = "Daily PNL"
        
        chartView.maxVisibleCount = 7
        chartView.doubleTapToZoomEnabled = false
        chartView.pinchZoomEnabled = false
        chartView.dragXEnabled = false
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        chartView.fitBars = true
        chartView.noDataText = "No data."
        chartView.drawGridBackgroundEnabled = false
        chartView.drawBordersEnabled = false
        chartView.rightAxis.enabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawZeroLineEnabled = true
        chartView.leftAxis.zeroLineColor = AppColors.label.secondary.withAlphaComponent(0.2)
        chartView.leftAxis.gridColor = AppColors.label.secondary.withAlphaComponent(0.2)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: days)
        chartView.xAxis.granularity = 1
        chartView.delegate = self
        //chartView.isUserInteractionEnabled = false
        
        addSubview(chartView)
        
        updateChartData(dataPoints: days, values: PNLs.map{ Double($0) })
    }
    
    // MARK: - Constraints
    
    override func makeConstraints() {
        super.makeConstraints()
        
        chartView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.right.equalToSuperview().offset(-CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(200)
            make.bottom.equalToSuperview().offset(-CONTENT_BOTTOM_MARGIN)
        }
    }
    
}


// MARK: - Chart view delegate and datasource

extension DailyPNLView: ChartViewDelegate {
    
    func updateChartData(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        chartDataSet.colors = PNLs.map { return setColor(value: $0) }
        
        let chartData = BarChartData(dataSet: chartDataSet)
        
        chartView.data = chartData
        
        chartView.animate(xAxisDuration: 0, yAxisDuration: 0.3, easingOptionX: .easeOutSine, easingOptionY: .easeOutSine)
    }
    
    func setColor(value: Double) -> UIColor {
        
        if value < 0 {
            return AppColors.accent.red
        } else if value > 0 {
            return AppColors.accent.green
        } else {
            return AppColors.label.secondary
        }
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {

        guard let dataSet = chartView.data?.dataSets[highlight.dataSetIndex] else { return }
        let _ = dataSet.entryIndex(entry: entry)
    }
    
}

class MarkerView: BaseView {
    
    lazy var valueLabel = UILabel()
    
    override func commonInit() {
        super.commonInit()
        
        valueLabel.font = .systemFont(ofSize: 13)
    }
}
