//
//  SortOrderButton.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 02/06/2021.
//

import UIKit
import Lottie
import Macaw


fileprivate enum ProgressKeyFrames: CGFloat {
    
    case start_1 = 20
    case end_1 = 40
    case start_2 = 105
    case end_2 = 125
  }

class SortOrderButton: RoundShadowView {
    
    lazy var arrowView = ArrowMacawView(frame: CGRect.zero)
    
    var ascendingOrder = true

    // MARK: - init methods
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        configure()
    }
    
    private func configure() {
        
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .label.withAlphaComponent(0.1)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap(_:)))
        addGestureRecognizer(tap)
        
        addSubview(arrowView)
        
    }
    
    @objc func onTap(_ sender: UIButton) {
        
        ascendingOrder = !ascendingOrder
        
        print("sort order:", ascendingOrder == false ? "descending": "ascending")
        
        arrowView.group.contentsVar.animate(to: ascendingOrder ? arrowView.contents1 : arrowView.contents2, during: 0.3)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.cornerRadius = frame.height/2
        
        arrowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func layoutIfNeeded() {
        
        arrowView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.layoutIfNeeded()
    }
    
}

