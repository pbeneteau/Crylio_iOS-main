//
//  DateRangeSelectorCollectionViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 24/05/2021.
//

import UIKit

class DateRangeSelectorCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "DateRangeSelectorCollectionViewCell"
    
    lazy var dateRangeLabel = UILabel()
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                setSelected()
            } else {
                setDeselected()
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        dateRangeLabel.font = .systemFont(ofSize: 15)
        dateRangeLabel.textAlignment = .center
        dateRangeLabel.clipsToBounds = true
        
        contentView.addSubview(dateRangeLabel)
    }
    
    func setSelected() {
        self.dateRangeLabel.backgroundColor = AppColors.buttonActiveBackground
    }
    
    func setDeselected() {
        self.dateRangeLabel.backgroundColor = .clear.withAlphaComponent(0)
    }
    
}


// MARK: - Constraints

extension DateRangeSelectorCollectionViewCell {
    
    override func layoutSubviews() {
        dateRangeLabel.snp.removeConstraints()
        
        dateRangeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(34)
        }
        
        super.layoutSubviews()
        
        dateRangeLabel.layer.cornerRadius = 10
    }
}
