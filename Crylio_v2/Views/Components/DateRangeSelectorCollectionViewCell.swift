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
        
        dateRangeLabel.font = .systemFont(ofSize: 13, weight: .medium)
        dateRangeLabel.textColor = AppColors.label.secondary
        dateRangeLabel.textAlignment = .center
        dateRangeLabel.layer.cornerRadius = 10
        dateRangeLabel.clipsToBounds = true
        dateRangeLabel.layer.masksToBounds = true

        contentView.addSubview(dateRangeLabel)
        
        dateRangeLabel.sizeToFit()
        
        dateRangeLabel.snp.remakeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setSelected() {
        
        dateRangeLabel.textColor = .white
        dateRangeLabel.backgroundColor = .systemBlue
    }
    
    func setDeselected() {
        
        dateRangeLabel.textColor = AppColors.label.secondary
        dateRangeLabel.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
