//
//  ChartLegendTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 20/05/2021.
//

import UIKit


class ChartLegendTableViewCell: UITableViewCell {
    
    static let reuseId = "LegendCell"
    
    lazy var dotView = RoundShadowView()
    lazy var nameLabel = UILabel()
    lazy var valueLabel = UILabel()
    
    var value: PieChartValue! {
        didSet {
            updateValues()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func commonInit() {
        
        //translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        selectionStyle = .none
        
        dotView.layer.cornerRadius = 2
        
        nameLabel.textColor = AppColors.label.secondary
        valueLabel.textColor = AppColors.label.primary
        
        nameLabel.font = .systemFont(ofSize: 15)
        valueLabel.font = .systemFont(ofSize: 15)
        
        valueLabel.textAlignment = .right
        
        addSubview(dotView)
        addSubview(nameLabel)
        addSubview(valueLabel)
        
        setNeedsUpdateConstraints()
    }
    
    private func updateValues() {
        
        dotView.backgroundColor = value.color
        nameLabel.text = value.name
        valueLabel.text = value.value.toPercentString()
    }

}


// MARKS: Constraints

extension ChartLegendTableViewCell {
    
    override func updateConstraints() {
        
        dotView.snp.makeConstraints { make in
            make.left.centerY.equalToSuperview()
            make.height.width.equalTo(10)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(dotView.snp.right).offset(8)
            make.right.equalTo(contentView.snp.centerX).inset(8)
            make.centerY.equalToSuperview().inset(2)
            make.height.equalTo(16)
        }
        
        valueLabel.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.centerX).offset(8)
            make.centerY.equalToSuperview().inset(2)
            make.right.equalToSuperview()
            make.height.equalTo(16)
        }
        
        super.updateConstraints()

    }
}
