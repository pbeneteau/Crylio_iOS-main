//
//  CryptoDetailBalanceView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 09/05/2021.
//

import UIKit

protocol CryptoDetailBalanceDelegate: NSObjectProtocol {
    func CryptoDetailBalanceTouched()
}

class CryptoDetailBalanceView: RoundShadowView {
    
    weak var delegate: CryptoDetailBalanceDelegate!
        
    lazy var iconView = UIImageView()
    lazy var titleLabel = UILabel()
    lazy var worthLabel = UILabel()
    lazy var amountLabel = UILabel()
    lazy var arrowView = UIImageView()
    
    var symbol: String! {
        didSet {
            titleLabel.text = "Balance"
        }
    }
    
    var worth: Float! {
        didSet {
            worthLabel.text = worth.toDollarString()
        }
    }
    
    var amount: Float! {
        didSet {
            amountLabel.text = amount.toAmountString(symbol: symbol!)
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
    
    func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 2
        layer.borderColor = AppColors.background.secondary.cgColor
        
        titleLabel.font = .systemFont(ofSize: 15)
        worthLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        amountLabel.font = .systemFont(ofSize: 15)
        
        amountLabel.textColor = AppColors.label.secondary
        
        worthLabel.textAlignment = .right
        amountLabel.textAlignment = .right
        
        arrowView.image = UIImage(named: "rightArrow")
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(_:))))
        
        addSubview(iconView)
        addSubview(titleLabel)
        addSubview(worthLabel)
        addSubview(amountLabel)
        addSubview(arrowView)
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        if let delegate = delegate {
            delegate.CryptoDetailBalanceTouched()
        }
    }
}


// MARK: - Constraints

extension CryptoDetailBalanceView {
    
    override func updateConstraints() {
        
        iconView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.width.height.equalTo(43)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(iconView.snp.right).offset(15)
            make.centerY.equalTo(iconView)
            make.right.equalTo(snp.centerX).inset(8)
            make.height.equalTo(18)
        }
        
        worthLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalTo(arrowView.snp.left).offset(-16)
            make.top.equalTo(CONTENT_TOP_MARGIN)
            make.height.equalTo(20)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalTo(arrowView.snp.left).offset(-16)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN)
            make.height.equalTo(18)
        }
        
        arrowView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalToSuperview()
            make.width.equalTo(5)
            make.height.equalTo(16)
        }
        
        super.updateConstraints()
    }
}
