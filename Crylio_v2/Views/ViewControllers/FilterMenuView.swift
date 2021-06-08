//
//  FilterMenuView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/05/2021.
//

import UIKit


protocol AssetsFilterDelegate: NSObjectProtocol {
    
    func filterDidChanged(_ sender: RoundCornersButton, order: FilterOrderingMode)
    func filterIsNotActive()
}

enum FilterOrderingMode {
    
    case ascending
    case descending
}


class FilterMenuView: UIView {
    
    lazy var nameFilterButton = RoundCornersButton()
    lazy var holdingsFilterButton = RoundCornersButton()
    lazy var priceFilterButton = RoundCornersButton()
        
    weak var delegate: AssetsFilterDelegate!
    
    var filterOrder: FilterOrderingMode = .descending
    
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
        
        nameFilterButton.setTitle("Name", for: .normal)
        holdingsFilterButton.setTitle("Holdings", for: .normal)
        priceFilterButton.setTitle("Price", for: .normal)
        
        nameFilterButton.setImage(UIImage(named: "filterInactiveIcon"), for: .normal)
        holdingsFilterButton.setImage(UIImage(named: "filterInactiveIcon"), for: .normal)
        priceFilterButton.setImage(UIImage(named: "filterInactiveIcon"), for: .normal)
        
        nameFilterButton.setImage(UIImage(named: "filterDescendingIcon"), for: .selected)
        holdingsFilterButton.setImage(UIImage(named: "filterDescendingIcon"), for: .selected)
        priceFilterButton.setImage(UIImage(named: "filterDescendingIcon"), for: .selected)
        
        nameFilterButton.setTitleColor(AppColors.label.primary, for: .normal)
        holdingsFilterButton.setTitleColor(AppColors.label.primary, for: .normal)
        priceFilterButton.setTitleColor(AppColors.label.primary, for: .normal)
        
        nameFilterButton.setTitleColor(.systemBlue, for: .selected)
        holdingsFilterButton.setTitleColor(.systemBlue, for: .selected)
        priceFilterButton.setTitleColor(.systemBlue, for: .selected)
        
        nameFilterButton.cornerRadius = 10
        holdingsFilterButton.cornerRadius = 10
        priceFilterButton.cornerRadius = 10

        nameFilterButton.borderWidth = 1.5
        holdingsFilterButton.borderWidth = 1.5
        priceFilterButton.borderWidth = 1.5
        
        nameFilterButton.borderColor = AppColors.background.tertiary
        holdingsFilterButton.borderColor = AppColors.background.tertiary
        priceFilterButton.borderColor = AppColors.background.tertiary
        
        nameFilterButton.borderColor = AppColors.background.secondary
        holdingsFilterButton.borderColor = AppColors.background.secondary
        priceFilterButton.borderColor = AppColors.background.secondary

        nameFilterButton.tag = 0
        holdingsFilterButton.tag = 1
        priceFilterButton.tag = 2
        
        nameFilterButton.addTarget(self, action: #selector(filterButtonPressed(sender:)), for: .touchUpInside)
        holdingsFilterButton.addTarget(self, action: #selector(filterButtonPressed(sender:)), for: .touchUpInside)
        priceFilterButton.addTarget(self, action: #selector(filterButtonPressed(sender:)), for: .touchUpInside)
        
        addSubview(nameFilterButton)
        addSubview(holdingsFilterButton)
        addSubview(priceFilterButton)
    }
    
}


// MARK: - Buttons action

extension FilterMenuView {
    
    @objc private func filterButtonPressed(sender: RoundCornersButton) {
        
        if sender.isSelected {
            /// filter active
            
            if filterOrder == .ascending {
                filterOrder = .descending
                sender.backgroundColor = .clear
                sender.borderWidth = 1.5
                sender.isSelected = false
                delegate.filterIsNotActive()
            } else {
                filterOrder = .ascending
                sender.setImage(UIImage(named: "filterAscendingIcon"), for: .selected)
                
                if let delegate = delegate {
                    delegate.filterDidChanged(sender, order: filterOrder)
                }
            }
        } else {
            /// filter inactive
            
            if nameFilterButton.state == .selected {
                nameFilterButton.backgroundColor = .clear
                nameFilterButton.borderWidth = 1.5
                nameFilterButton.isSelected = false
            }
            if holdingsFilterButton.state == .selected {
                holdingsFilterButton.backgroundColor = .clear
                holdingsFilterButton.borderWidth = 1.5
                holdingsFilterButton.isSelected = false
            }
            if priceFilterButton.state == .selected {
                priceFilterButton.backgroundColor = .clear
                priceFilterButton.borderWidth = 1.5
                priceFilterButton.isSelected = false
            }
            
            sender.backgroundColor = AppColors.buttonActiveBackground
            sender.layer.borderWidth = 0
            sender.isSelected = true
            sender.setImage(UIImage(named: "filterDescendingIcon"), for: .selected)
            
            filterOrder = .descending
            
            if let delegate = delegate {
                delegate.filterDidChanged(sender, order: filterOrder)
            }
        }        
    }
}
 

// MARK: - Constraints

extension FilterMenuView {
    
    override func updateConstraints() {
        
        nameFilterButton.snp.makeConstraints { make in
            make.left.top.bottom.equalToSuperview()
        }

        priceFilterButton.snp.makeConstraints { make in
            make.left.equalTo(nameFilterButton.snp.right).offset(10)
            make.top.bottom.equalToSuperview()
        }
        
        holdingsFilterButton.snp.makeConstraints { make in
            make.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        super.updateConstraints()

    }
}
