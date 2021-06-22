//
//  HomeHeaderView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit


class HomeHeaderView: BackgroundBoxView {
    
    lazy var portfolioLabel = UILabel()
    lazy var changeLabel = UILabel()
    lazy var worthLabel = UILabel()
    
    lazy var chartContainerView = UIView()
    lazy var lineChart = CustomLineChartView()
    
    var chartInitialized = false
    
    override func commonInit() {
        super.commonInit()
        
        layer.cornerRadius = 10
        translatesAutoresizingMaskIntoConstraints = false
        layer.shadowOpacity = 0.1
        clipsToBounds = true
        
        chartContainerView.layer.cornerRadius = 10
        chartContainerView.clipsToBounds = true
        
        lineChart.pointEntries = generateRandomEntries()
        
        portfolioLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        portfolioLabel.textColor = .white
        portfolioLabel.alpha = 0.7
        
        changeLabel.textAlignment = .center
        changeLabel.layer.cornerRadius = 5
        changeLabel.clipsToBounds = true
        changeLabel.textColor = .white
        changeLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        
        worthLabel.font = .systemFont(ofSize: 34, weight: .bold)
        worthLabel.textColor = .white
        
        addSubview(portfolioLabel)
        addSubview(changeLabel)
        addSubview(worthLabel)
        addSubview(chartContainerView)
        chartContainerView.addSubview(lineChart)
        bringSubviewToFront(worthLabel)
        
        updateValues(portfolioName: "Main Portfolio", portfolioBalance: 84415.97, portfolioChange: -12.73)
    }
    
    func updateValues(portfolioName: String, portfolioBalance: Float, portfolioChange: Float) {
        
        portfolioLabel.text = portfolioName
        worthLabel.setDollarMutableString(value: portfolioBalance)
        changeLabel.setPercentMutableString(value: portfolioChange, colors: true)
        
        setHeaderColor(change: portfolioChange)
    }
    
    private func generateRandomEntries() -> [PointEntry] {
        
        var result: [PointEntry] = []
        for i in 0..<14 {
            let value = Float.random(in: 50000...100000)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "d MMM"
            var date = Date()
            date.addTimeInterval(TimeInterval(24*60*60*i))
            
            result.append(PointEntry(value: value, label: formatter.string(from: date)))
        }
        return result
    }
    
    private func setHeaderColor(change: Float) {
        
        if change < 0 {
            backgroundColor = UIColor(hexString: "#ff414c")
            lineChart.fillColor = UIColor(hexString: "#ff5e65")
            changeLabel.backgroundColor = UIColor(hexString: "#ff5e65")
        } else if change > 0 {
            backgroundColor = UIColor(hexString: "#10AC84")
            lineChart.fillColor = UIColor(hexString: "#1DD1A1")
            changeLabel.backgroundColor = UIColor(hexString: "#1DD1A1")
        } else {
            backgroundColor = UIColor(hexString: "#8395A7")
            lineChart.fillColor = UIColor(hexString: "#C8D6E5")
            changeLabel.backgroundColor = UIColor(hexString: "#C8D6E5")
        }
        
        changeLabel.textColor = .white
    }
    
    func updateLayout(_ delta: CGFloat) {
        
        portfolioLabel.alpha = 1 - 0.3*delta
        worthLabel.alpha = delta
        chartContainerView.alpha = delta
        let center = frame.width/2 - portfolioLabel.frame.width/2
        portfolioLabel.transform = CGAffineTransform(translationX: center*(1-delta), y: 0)
    }
    
}


// MARK: - Constraints

extension HomeHeaderView {
    
    override func updateConstraints() {
        
        portfolioLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(15)
            make.right.equalTo(snp.centerX).inset(8)
            make.height.equalTo(20)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(11)
            make.top.equalTo(11)
            make.width.equalTo(changeLabel.intrinsicContentSize.width + 20)
            make.height.equalTo(28)
        }
        
        worthLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(portfolioLabel.snp.bottom).offset(5)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.height.equalTo(41)
        }
        
        chartContainerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(worthLabel.snp.bottom).offset(5)
            make.height.equalTo(64)
        }
        
        lineChart.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(15)
        }
        
        super.updateConstraints()
    }
}
