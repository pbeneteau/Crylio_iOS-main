//
//  MajorHoldingsBubblesView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/06/2021.
//

import Foundation
import UIKit


class AssetAllocationBubblesView: BaseView {
    
    lazy var crypto0BubbleView = CircleView()
    lazy var crypto1BubbleView = CircleView()
    lazy var crypto2BubbleView = CircleView()
    lazy var crypto3BubbleView = CircleView()
    
    lazy var crypto1PortionLabel = UILabel()
    lazy var crypto2PortionLabel = UILabel()
    lazy var crypto3PortionLabel = UILabel()
    
    var items: [String:AssetAllocationItem]! {
        didSet {
            updateValues()
        }
    }
    
    override func commonInit() {
        super.commonInit()
            
        crypto1PortionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        crypto2PortionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        crypto3PortionLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        crypto1PortionLabel.textColor = .white
        crypto2PortionLabel.textColor = .white
        crypto3PortionLabel.textColor = .white
        
        crypto1PortionLabel.textAlignment = .center
        crypto2PortionLabel.textAlignment = .center
        crypto3PortionLabel.textAlignment = .center
        
        crypto1PortionLabel.adjustsFontSizeToFitWidth = true
        crypto2PortionLabel.adjustsFontSizeToFitWidth = true
        crypto3PortionLabel.adjustsFontSizeToFitWidth = true
        
        addSubview(crypto0BubbleView)
        addSubview(crypto3BubbleView)
        addSubview(crypto3PortionLabel)
        addSubview(crypto2BubbleView)
        addSubview(crypto2PortionLabel)
        addSubview(crypto1BubbleView)
        addSubview(crypto1PortionLabel)
        
        setNeedsUpdateConstraints()
    }
    
    private func updateValues() {
        
        for (key, item) in items {
            switch key {
            case "other":
                crypto0BubbleView.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(Float(frame.height)*item.value/100)
                }
                crypto0BubbleView.backgroundColor = item.accentColor
            case "thirdAsset":
                let crypto1Height = max(Float(frame.height)*item.value/100, Float(frame.height)*item.value/35)
                let crypto1Delta = (crypto1Height - (crypto1Height * cos(Float.pi/4) + crypto1Height/2))*(item.value/100)
                crypto1BubbleView.snp.remakeConstraints { make in
                    make.left.equalTo(snp.centerX).offset(-crypto1Delta+5)
                    make.top.equalTo(snp.centerY).offset(-crypto1Delta+5)
                    make.height.width.equalTo(crypto1Height)
                }
                crypto1BubbleView.backgroundColor = item.accentColor
                crypto1PortionLabel.text = item.value.toPercentString()
            case "secondAsset":
                let crypto2Height = max(Float(frame.height)*item.value/100, Float(frame.height)*item.value/35)
                let crypto2Delta = (crypto2Height - (crypto2Height * cos(Float.pi/4) + crypto2Height/2))*(item.value/100)
                crypto2BubbleView.snp.remakeConstraints { make in
                    make.right.equalTo(snp.centerX).offset(crypto2Delta-5)
                    make.top.equalTo(snp.centerY).offset(-crypto2Delta+5)
                    make.height.width.equalTo(crypto2Height)
                }
                crypto2BubbleView.backgroundColor = item.accentColor
                crypto2PortionLabel.text = item.value.toPercentString()
            case "firstAsset":
                crypto3BubbleView.snp.remakeConstraints { make in
                    make.center.equalToSuperview()
                    make.height.width.equalTo(max(Float(frame.height)*item.value/100, Float(frame.height)*item.value/50))
                }
                crypto3BubbleView.backgroundColor = item.accentColor
                crypto3PortionLabel.text = item.value.toPercentString()
            default:
                return
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
       updateValues()
        
        crypto0BubbleView.layer.cornerRadius = crypto0BubbleView.frame.height/2
        crypto1BubbleView.layer.cornerRadius = crypto1BubbleView.frame.height/2
        crypto2BubbleView.layer.cornerRadius = crypto2BubbleView.frame.height/2
        crypto3BubbleView.layer.cornerRadius = crypto3BubbleView.frame.height/2
    }
    
    
    // MARK: - Constraints
    
    override func makeConstraints() {
        
        crypto1PortionLabel.snp.makeConstraints { make in
            make.center.equalTo(crypto1BubbleView)
            make.width.equalTo(crypto1BubbleView).offset(-6).priority(999)
            make.height.equalTo(crypto1PortionLabel.intrinsicContentSize.height)
        }
        
        crypto2PortionLabel.snp.makeConstraints { make in
            make.center.equalTo(crypto2BubbleView)
            make.width.equalTo(crypto2BubbleView).offset(-6).priority(999)
            make.height.equalTo(crypto2PortionLabel.intrinsicContentSize.height)
        }
        
        crypto3PortionLabel.snp.makeConstraints { make in
            make.center.equalTo(crypto3BubbleView)
            make.width.equalTo(crypto3BubbleView).offset(-6).priority(999)
            make.height.equalTo(crypto3PortionLabel.intrinsicContentSize.height)
        }
    }
}
