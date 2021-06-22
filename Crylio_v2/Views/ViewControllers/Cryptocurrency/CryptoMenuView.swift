//
//  CryptoMenuView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 30/01/2021.
//

import UIKit


protocol HorizontalMenuProtocol: NSObjectProtocol {
    func menuButtonTapped(sender: UIButton!)
}

class CryptoMenuView: BaseView {
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.contentInsetAdjustmentBehavior = .never
        view.clipsToBounds = false
        view.layer.masksToBounds = false
        return view
    }()
    
    var buttons = [UIButton]()
    lazy var selectedButtonView = BackgroundBoxView()
    var selectedButtonTag = 0
    
    weak var delegate: HorizontalMenuProtocol? = nil
    
    var items = [String]()
    
    init(items: [String]) {
        self.items = items
        super.init(frame: CGRect.zero)        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func commonInit() {
        super.commonInit()
                
        backgroundColor = .clear
        
        layer.masksToBounds = false
        clipsToBounds = false
                
        selectedButtonView.shadowView.backgroundColor = AppColors.background.secondary
        selectedButtonView.translatesAutoresizingMaskIntoConstraints = false
        
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
            button.translatesAutoresizingMaskIntoConstraints = false
            
            buttons.append(button)
            scrollView.addSubview(button)
        }
                
        buttons[selectedButtonTag].isSelected = true
    }
    
    func setSelectedButton(index: Int) {
        
        selectedButtonTag = index
        
        UIView.animate(withDuration: 0.2, delay: 0, options: [.beginFromCurrentState, .curveEaseOut]) {
            
            self.selectedButtonView.snp.remakeConstraints { make in
                make.edges.equalTo(self.buttons[index])
            }
            self.layoutIfNeeded()
        }
    }
    
    @objc func buttonTapped(sender: UIButton!) {
        
        if let delegate = delegate {
            delegate.menuButtonTapped(sender: sender)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        selectedButtonView.snp.remakeConstraints { make in
            make.edges.equalTo(buttons[selectedButtonTag])
        }
        
        resizeScrollViewContent()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        resizeScrollViewContent()
    }
    
    func resizeScrollViewContent() {
        
        scrollView.contentSize = CGSize(width: (buttons.last?.frame.maxX)!, height: frame.height)
    }
    
}


// MARK: - Constraints

extension CryptoMenuView {
    
    override func updateConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setButtonsConstraints()
        
        super.updateConstraints()
    }
    
    func setButtonsConstraints() {
                
        for (index, button) in buttons.enumerated() {
            
            let minButtonWidth = button.intrinsicContentSize.width + 30
            
            if index == 0 {
                button.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
                    make.top.equalToSuperview().offset(7)
                    make.height.equalToSuperview().offset(-23)
                    make.width.equalTo(minButtonWidth)
                }
            } else {
                button.snp.makeConstraints { make in
                    make.left.equalTo(buttons[index-1].snp.right).offset(5)
                    make.top.equalToSuperview().offset(7)
                    make.height.equalToSuperview().offset(-23)
                    make.width.equalTo(minButtonWidth)
                }
            }
        }
    }
}
