//
//  FavoriteFilterButtonView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 02/06/2021.
//

import UIKit

class FavoriteFilterButtonView: RoundCornersButton {
    
    let image = UIImage(named: "starEmpty")!.withRenderingMode(.alwaysTemplate)

    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = AppColors.background.tertiary
        tintColor = .label
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        setImage(UIImage(named: "starEmpty"), for: .normal)
        setImage(UIImage(named: "starFilled")?.withRenderingMode(.alwaysTemplate), for: .selected)
        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        print("filtered by favorites")
        
        isSelected = !isSelected

        if isSelected {
            tintColor = .systemBlue
        } else {
            tintColor = .label
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height/2
    }

}
