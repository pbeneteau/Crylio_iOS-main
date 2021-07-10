//
//  SettingsTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 10/07/2021.
//

import UIKit

public enum SettingsTableViewCellPosition {
    case top
    case middle
    case bottom
    case alone
}

open class SettingsTableViewCell: UITableViewCell, Configurable {
    
    lazy var containerView = UIView()
    
    var position: SettingsTableViewCellPosition?

    override required public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        commonInit()
    }

    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {

        
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        containerView.backgroundColor = AppColors.background.secondary
        containerView.clipsToBounds = true
                
        contentView.addSubview(containerView)
        contentView.sendSubviewToBack(containerView)
        
        setNeedsUpdateConstraints()
    }
    
    // MARK: - Configurable
    
    open func configure(with row: Row & RowStyle, position: SettingsTableViewCellPosition) {
        
        switch position {
        case .top:
            containerView.roundCorners([.topLeft, .topRight], radius: 10)
        case .bottom:
            containerView.roundCorners([.bottomLeft, .bottomRight], radius: 10)
        case .alone:
            containerView.layer.cornerRadius = 10
        default:
            break
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        frame.origin.x = SAFE_AREA_MARGIN
        frame.size.width = UIScreen.main.bounds.width - 2 * SAFE_AREA_MARGIN
        
        imageView?.frame.origin.x = CONTENT_HORIZONTAL_MARGIN
        textLabel?.frame.origin.x = CONTENT_HORIZONTAL_MARGIN + (imageView?.frame.width ?? 30) + 10
        detailTextLabel?.frame.origin.x = CONTENT_HORIZONTAL_MARGIN + (imageView?.frame.width ?? 30) + 10
    }
    
    open override func updateConstraints() {
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        super.updateConstraints()
    }
}
