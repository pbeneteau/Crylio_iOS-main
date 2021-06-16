//
//  SortByButtonView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 02/06/2021.
//

import UIKit

class SortByButtonView: UIView {
    
    lazy var sortByButton = UIButton()
    lazy var sortOrderButton = SortOrderButton()
    
    var options = ["Rank", "Change", "Market Cap", "Volume", "Circulating Supply", "Price", "Name"]
    
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
        backgroundColor = AppColors.background.tertiary
        
        sortByButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        
        addSubview(sortByButton)
        addSubview(sortOrderButton)
        
        initValues()
    }
    
    private func initValues() {
                
        let attriText = NSMutableAttributedString(string: "Sort by: " + options[0], attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemBlue])
        
        attriText.addAttribute(NSAttributedString.Key.foregroundColor, value: AppColors.label.secondary, range: NSRange(location:0, length:"Sort by:".count))
        
        attriText.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 15, weight: .regular), range: NSRange(location:0, length:"Sort by:".count))
        
        sortByButton.setAttributedTitle(attriText, for: .normal)
        
        layoutIfNeeded()
    }
        
}


// MARK: - Constraints

extension SortByButtonView {

    override func layoutIfNeeded() {
        super.layoutIfNeeded()

        sortByButton.snp.removeConstraints()
        sortOrderButton.snp.removeConstraints()
        
        sortByButton.snp.makeConstraints { make in
            make.left.equalTo(12)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(sortByButton.intrinsicContentSize.width + 3)
        }
        
        sortOrderButton.snp.makeConstraints { make in
            make.left.equalTo(sortByButton.snp.right).offset(8)
            make.right.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(23)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height/2
    }
    
}
