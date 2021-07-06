//
//  NavigationTopBarView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 31/01/2021.
//

import UIKit

protocol NavigationTopBarDelegate: NSObjectProtocol {
    func backButtonAction()
}

class NavigationTopBarView: BaseView {
    
    lazy var topBar = UIView()
    
    let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .regular))

    /// left
    lazy var backButton = UIButton(type: .custom)
    
    /// center
    lazy var titleLabel = UILabel()
    lazy var changeLabel = UILabel()
    
    // right
    lazy var addToFavoriteButton = AddToFavoriteButton()
    
    var isTitleHidden = true
    var isBlurriedViewHidden = true
    
    weak var delegate: NavigationTopBarDelegate!
    
    override func commonInit() {
        super.commonInit()
                
        topBar.backgroundColor = AppColors.background.primary
        
        blurredView.backgroundColor = AppColors.blur
        blurredView.addBottomBorder()
        blurredView.alpha = 0

        // create chevron image
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .light, scale: .default)
        let image = UIImage(systemName: "chevron.left", withConfiguration: config)
        
        backButton.setTitle("Home", for: .normal)
        backButton.setImage(image, for: .normal)
        backButton.titleEdgeInsets.left = 4.33
        backButton.titleLabel?.font = .systemFont(ofSize: 17)
        backButton.setTitleColor(backButton.tintColor, for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonAction(sender:)), for: .touchUpInside)
        
        titleLabel.alpha = 0
        titleLabel.textAlignment = .right
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        changeLabel.alpha = 0
        changeLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        addSubview(blurredView)
        addSubview(topBar)
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(changeLabel)
        addSubview(addToFavoriteButton)
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
        
        if let delegate = delegate {
            delegate.backButtonAction()
        }
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
            make.left.equalTo(9.33)
            make.top.equalTo(57.33)
            make.height.equalTo(23)
            make.width.equalTo(backButton.intrinsicContentSize.width+backButton.titleEdgeInsets.left)
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
        
        addToFavoriteButton.snp.remakeConstraints { make in
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.centerY.equalTo(backButton)
            make.height.width.equalTo(21)
        }
        
        super.updateConstraints()
    }
}
