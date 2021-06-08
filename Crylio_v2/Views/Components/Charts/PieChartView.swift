//
//  PieChartView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 20/05/2021.
//

import UIKit
import Charts


struct PieChartValue {
    
    var name: String
    var value: Float
    var color: UIColor
}

class PieChartView_2: UIView {
    
    lazy var chartView = PieChartView()
    lazy var legendView = ChartLegendView()
    
    var enableLegend = true
    
    var values: [String: Float]! {
        didSet {
            updateData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        chartView.backgroundColor = .clear
        chartView.holeColor = .clear
        chartView.transparentCircleColor = .clear
        chartView.entryLabelColor = .clear
        
        isUserInteractionEnabled = false
        
        chartView.drawEntryLabelsEnabled = false
        chartView.legend.enabled = false
        chartView.holeRadiusPercent = 0.6
        
        addSubview(chartView)
        
        if enableLegend {
            
            addSubview(legendView)
        }
    }
    
    func updateData() {
        
        let chartValues = self.values.enumerated().map { (index, arg1) -> PieChartValue in
            
            let (key, value) = arg1
            return PieChartValue(name: key, value: value, color: AppColors.chart[index])
        }
        
        updateChartData(chartValues)
        updateLegendData(chartValues)
    }
    
    fileprivate func updateChartData(_ values: [PieChartValue]) {
        
        let entries = values.map() { (value: PieChartValue) -> PieChartDataEntry in
            
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(value.value))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.drawIconsEnabled = false
        set.sliceSpace = 0
        
        set.colors = AppColors.chart
        
        let data = PieChartData(dataSet: set)
        
        data.setDrawValues(false)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    fileprivate func updateLegendData(_ values: [PieChartValue]) {
        
        legendView.values = values
    }
    
}


// MARKS: Constraints

extension PieChartView_2 {
    
    override func updateConstraints() {
        
        if enableLegend {
            
            chartView.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(10)
                make.top.bottom.equalToSuperview()
                make.width.equalTo(chartView.snp.height)
            }
            
            legendView.snp.makeConstraints { make in
                make.left.equalTo(self.snp.centerX)
                make.top.equalToSuperview().offset(10)
                make.right.bottom.equalToSuperview().inset(16)
            }
        } else {
            
            chartView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.width.equalToSuperview()
            }
        }
        
        super.updateConstraints()
    }
}
