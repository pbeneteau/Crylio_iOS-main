//
//  ChangeTimelineButton.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 02/06/2021.
//

import UIKit

class ChangeTimelineButton: RoundCornersButton {

    let timelines = ["1h", "24h", "1w"]

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
        backgroundColor = .label.withAlphaComponent(0.1)
        
        titleLabel?.font = .systemFont(ofSize: 15, weight: .medium)
        titleLabel?.textAlignment = .center

        setTitleColor(AppColors.label.primary, for: .normal)

        contentEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        
        setTitle(timelines[0], for: .normal)
        setTitle(timelines[1], for: .selected)
        
        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        print("filtered by timeline")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height/2
    }

}
