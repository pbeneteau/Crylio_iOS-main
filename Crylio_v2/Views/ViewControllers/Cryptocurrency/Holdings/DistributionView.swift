//
//  DistributionView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/03/2021.
//

import UIKit
import Charts


class DistributionView: BackgroundBoxWithTitleView {
    
    lazy var statesTitle = UILabel()
    lazy var pieChartView = PieChartView_2()
    
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
    
    
    override func commonInit() {
        super.commonInit()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = "Assets States"
        pieChartView.values = ["stacked": 34.42, "on order": 12.95, "available": 48.6, "on trade": 4.03]
   
        addSubview(pieChartView)
    }

}


// MARKS: Constraints

extension DistributionView {
    
    override func updateConstraints() {
        
        pieChartView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(pieChartView.snp.width).multipliedBy(0.4)
        }

        super.updateConstraints()
        
    }
}
