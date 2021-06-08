//
//  AddToFavoriteButton.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 25/05/2021.
//

import UIKit

protocol AddToFavoriteButtonDelegate: NSObjectProtocol {
    func favoriteStateDidChange(favorite: Bool)
}

class AddToFavoriteButton: UIView {
    
    lazy var starView = UIImageView(image: UIImage(named: "starFilled")?.withRenderingMode(.alwaysTemplate))
    
    lazy var added = false
    
    weak var delegate: AddToFavoriteButtonDelegate!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
                
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapView(_:))))
        
        starView.tintColor = .label
        
        addSubview(starView)
    }
    
    @objc private func didTapView(_ sender: UIView) {
        
        added = !added

        if let delegate = delegate {
            delegate.favoriteStateDidChange(favorite: added)
        }
        
        if !added {
            animateStarBump(scaleFactor: 1.3, duration: 0.25)
            starView.tintColor = .label
        } else {
            animateStarBump(scaleFactor: 1.3, duration: 0.25)
            starView.tintColor = .systemBlue
        }
        print((added ? "added to" : "removed from") + " favourites")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func animateStarBump(scaleFactor: CGFloat, duration: Double) {
        
        UIView.animate(withDuration: duration/2, animations: {
            
            self.starView.transform = CGAffineTransform(scaleX: scaleFactor, y: scaleFactor)
        },
        completion: { _ in
            UIView.animate(withDuration: duration/2) {
                self.starView.transform = CGAffineTransform.identity
            }
        })
    }
        
}


// MARK: - Constraints

extension AddToFavoriteButton {
    
    override func updateConstraints() {
        
        starView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateConstraints()
    }
}
