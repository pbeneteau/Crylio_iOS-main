//
//  DistributionView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/03/2021.
//

import UIKit
import Charts


class DistributionView: UIView {
    
    lazy var title = UILabel()
    
    lazy var backgroundBox = UIView()
    
    lazy var statesTitle = UILabel()
    
    lazy var pieChartView = PieChartView_2()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    init(onOrder: Float,
         onTrade: Float,
         stacked: Float,
         available: Float) {
        
        super.init(frame: CGRect.zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    
    private func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
                
        backgroundBox.backgroundColor = AppColors.background.secondary
        
        backgroundBox.layer.cornerRadius = 10
        
        title.text = "Distribution"
        statesTitle.text = "States"
        
        title.font = .systemFont(ofSize: 20, weight: .bold)
        title.textColor = .label
                
        pieChartView.values = ["stacked": 34.42, "on order": 12.95, "available": 48.6, "on trade": 4.03]
        
        addSubview(title)
        addSubview(backgroundBox)
        backgroundBox.addSubview(statesTitle)
        
        backgroundBox.addSubview(pieChartView)
    }

}


// MARKS: Constraints

extension DistributionView {
    
    override func updateConstraints() {
        
        title.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.width.equalTo(200)
            make.top.equalToSuperview()
            make.height.equalTo(22)
        }
        
        backgroundBox.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(title.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        pieChartView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(pieChartView.snp.width).multipliedBy(0.4)
        }

        super.updateConstraints()
        
    }
}
