//
//  HorizontalMenuView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 30/01/2021.
//

import UIKit


protocol HorizontalMenuProtocol: NSObjectProtocol {
    func menuButtonTapped(sender: UIButton!)
}

class HorizontalMenu: UIView {
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .systemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    lazy var selectedButtonView = RoundShadowView()
    
    var buttons = [UIButton]()
    
    var scrollable = true
    var selectedButtonTag = 0
    
    weak var delegate: HorizontalMenuProtocol? = nil
    
    var items = [String]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    init(items: [String], scrollable: Bool) {
        super.init(frame: CGRect.zero)
        
        self.items = items
        self.scrollable = scrollable
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        
        layer.cornerRadius = 10
        backgroundColor = .clear
        
        scrollView.backgroundColor = .clear
                
        selectedButtonView.backgroundColor = AppColors.background.secondary
        
        selectedButtonView.layer.cornerRadius = 10
        
        addSubview(scrollView)
        scrollView.addSubview(selectedButtonView)
        
        for (index, item) in items.enumerated() {
            let button = UIButton()
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            button.tag = index
            button.tintColor = .label
            button.setTitleColor(.label, for: .selected)
            button.setTitleColor(.label, for: .normal)
            button.addTarget(self, action: #selector(self.buttonTapped(sender:)), for: .touchUpInside)
            
            buttons.append(button)
            scrollView.addSubview(button)
        }
        
        buttons[selectedButtonTag].isSelected = true
    }
    
    func setSelectedButton(index: Int) {
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
            
            self.selectedButtonView.snp.remakeConstraints { make in
                make.edges.equalTo(self.buttons[index])
                make.width.height.equalTo(self.buttons[index])
            }
            self.layoutIfNeeded()
        }
    }
    
    func adjustSelectedButtonViewPositionBasedOn(scrollViewXOffset: CGFloat) {
        
        selectedButtonView.snp.remakeConstraints { make in
            
        }
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        self.delegate?.menuButtonTapped(sender: sender)
    }
    
    override func updateConstraints() {
                        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
    func setButtonsConstraints() {
        
        let maxButtonWidth = self.frame.width / CGFloat(buttons.count)

        for (index, button) in buttons.enumerated() {
            
            if scrollable {
                
                let minButtonWidth = button.intrinsicContentSize.width + 30

                if index == 0 {
                    button.snp.makeConstraints { make in
                        make.top.equalToSuperview().offset(10)
                        make.bottom.equalToSuperview().inset(10)
                        make.left.equalToSuperview()
                        make.width.equalTo(minButtonWidth)
                    }
                } else {
                    button.snp.makeConstraints { make in
                        make.top.equalToSuperview().offset(10)
                        make.bottom.equalToSuperview().inset(10)
                        make.left.equalTo(buttons[index-1].snp.right).offset(5)
                        make.width.equalTo(minButtonWidth)
                    }
                }
            } else {
                
                if index == 0 {
                    button.snp.makeConstraints { make in
                        make.top.equalToSuperview().offset(10)
                        make.bottom.equalToSuperview().inset(10)
                        make.left.equalToSuperview()
                        make.width.equalTo(maxButtonWidth)
                    }
                } else {
                    button.snp.makeConstraints { make in
                        make.top.equalToSuperview().offset(10)
                        make.bottom.equalToSuperview().inset(10)
                        make.left.equalTo(buttons[index-1].snp.right)
                        make.width.equalTo(maxButtonWidth)
                    }
                }
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setButtonsConstraints()
        
        selectedButtonView.snp.makeConstraints { make in
            make.edges.equalTo(buttons[selectedButtonTag])
        }
        
        resizeScrollViewContent()
    }
    
    func resizeScrollViewContent() {
        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize.width = contentRect.size.width
    }
    
}

