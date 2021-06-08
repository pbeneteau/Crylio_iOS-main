//
//  PriceChangeBoxView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/01/2021.
//

import UIKit
import SnapKit


class PriceChangeBox: UIView {
    
    lazy var boxView = UIImageView()
    lazy var changeLabel = UILabel()
    
    var change: Float! {
        didSet {
            initValues()
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
        
        backgroundColor = .clear
        
        changeLabel.textAlignment = .right
                
        addSubview(boxView)
        addSubview(changeLabel)
    }
    
    func initValues() {
        
        boxView.image = UIImage(named: "priceUp")
        
        if change < 0 {
            boxView.image = UIImage(named: "priceDown")
        }
        
        changeLabel.setPercentMutableString(value: change, colors: true)
    }
    
    override func updateConstraints() {
        
        boxView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(self.snp.height)
        }
        
        changeLabel.snp.makeConstraints { make in
            make.left.equalTo(boxView.snp.right).offset(5)
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(changeLabel.intrinsicContentSize.width)
        }
        
        super.updateConstraints()
    }
    
    
}
