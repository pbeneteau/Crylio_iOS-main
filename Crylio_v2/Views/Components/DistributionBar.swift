//
//  DistributionBar.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 15/03/2021.
//

import UIKit


struct BarValue {
    var percent: Float
    var color: UIColor
    var name: String
}


class DistributionBar: RoundShadowView {
    
    var items = [BarValue]()
    
    var bars = [UIView]()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    init(values: [BarValue]) {
        super.init(frame: CGRect.zero)
        
        self.items = values
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }

    private func commonInit() {
        
        layer.cornerRadius = 7
        layer.masksToBounds = true
        
        for item in items {
            
            let bar = UIView()
            
            bar.backgroundColor = item.color
            
            bars.append(bar)
            addSubview(bar)
        }
        
    }
    
    override func updateConstraints() {
        
        for (index, bar) in bars.enumerated() {

            if index == 0 {
                bar.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.height.equalToSuperview()
                    make.left.equalToSuperview()
                    make.width.equalToSuperview().multipliedBy(items[index].percent)
                }
            } else {
                bar.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.height.equalToSuperview()
                    make.left.equalTo(bars[index-1].snp.right)
                    make.width.equalToSuperview().multipliedBy(items[index].percent)                }
            }
        }
        
        super.updateConstraints()

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
}
