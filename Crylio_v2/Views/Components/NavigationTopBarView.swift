//
//  NavigationTopBarView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 31/01/2021.
//

import UIKit

protocol NavigationTopBarDelegate: NSObjectProtocol {
    func backButtonAction()
    func addButtonAction()
}

class NavigationTopBarView: UIView {
    
    lazy var topBar = UIView()
    
    let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    /// left
    lazy var backButton = UIButton(type: .custom)
    
    /// center
    lazy var titleLabel = UILabel()
    lazy var changeLabel = UILabel()
    
    // right
    lazy var addToFavoriteButton = AddToFavoriteButton()
    lazy var addTransactionButton = UIButton()
    
    var isTitleHidden = true
    var isBlurriedViewHidden = true
    
    weak var backButtonDelegate: NavigationTopBarDelegate!
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
                
        topBar.backgroundColor = AppColors.background.primary
        
        blurredView.backgroundColor = AppColors.blur
        blurredView.alpha = 0

        // create chevron image
        let config = UIImage.SymbolConfiguration(pointSize: 25.0, weight: .medium, scale: .medium)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        
        backButton.setTitle(" Back", for: .normal)
        backButton.setImage(image, for: .normal)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction(sender:)), for: .touchUpInside)
        
        titleLabel.alpha = 0
        titleLabel.textAlignment = .right
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        changeLabel.alpha = 0
        changeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addTransactionButton.setImage(UIImage(named: "add"), for: .normal)
        addTransactionButton.addTarget(self, action: #selector(addButtonAction(sender:)), for: .touchUpInside)
        
        addBottomBorder()
        
        addSubview(blurredView)
        addSubview(topBar)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(changeLabel)
        addSubview(addToFavoriteButton)
        addSubview(addTransactionButton)
    }
    
    func hideTitle() {
        
        if isTitleHidden { return }
        isTitleHidden = true
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.titleLabel.alpha = 0
            self.titleLabel.transform = CGAffineTransform(translationX: 0, y: 5)
            self.changeLabel.alpha = 0
            self.changeLabel.transform = CGAffineTransform(translationX: 0, y: 5)
        })
    }
    
    func showTitle() {
        
        if !isTitleHidden { return }
        isTitleHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseOut, .beginFromCurrentState], animations: {
            self.titleLabel.alpha = 1
            self.titleLabel.transform = CGAffineTransform.identity
            self.changeLabel.alpha = 1
            self.changeLabel.transform = CGAffineTransform.identity
        })
    }
    
    @objc func backButtonAction(sender: UIButton!) {
        
        if let delegate = backButtonDelegate {
            delegate.backButtonAction()
        }
    }
    
    @objc func addButtonAction(sender: UIButton!) {
        
        if let delegate = backButtonDelegate {
            delegate.addButtonAction()
        }
    }
    
    func addBottomBorder() {
        
        let border = UIView()
        border.backgroundColor = .systemGray.withAlphaComponent(0.1)
        border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
        border.frame = CGRect(x: 0, y:  blurredView.frame.size.height - 0.3, width:  blurredView.frame.size.width, height: 0.3)
        blurredView.contentView.addSubview(border)
    }
}


// MARK: - Constraints

extension NavigationTopBarView {
        
    override func updateConstraints() {
                
        blurredView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.width.equalToSuperview()
        }
        
        topBar.snp.makeConstraints { make in
            make.left.top.width.equalToSuperview()
            make.height.equalTo(91)
        }
        
        backButton.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.top.equalTo(55)
            make.height.equalTo(22)
            make.width.equalTo(100)
        }
        
        titleLabel.snp.remakeConstraints { make in
            make.right.equalTo(snp.centerX).inset(5)
            make.centerY.equalTo(backButton)
            make.height.equalTo(20)
            make.width.equalTo(titleLabel.intrinsicContentSize.width)
        }
        
        changeLabel.snp.remakeConstraints { make in
            make.left.equalTo(snp.centerX).offset(5)
            make.centerY.equalTo(backButton)
            make.height.equalTo(20)
            make.width.equalTo(changeLabel.intrinsicContentSize.width)
        }
        
        addTransactionButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.centerY.equalTo(backButton)
            make.height.width.equalTo(21)
        }
        
        addToFavoriteButton.snp.remakeConstraints { make in
            make.right.equalTo(addTransactionButton.snp.left).offset(-13)
            make.centerY.equalTo(backButton)
            make.height.width.equalTo(21)
        }
        
        super.updateConstraints()
    }
}
