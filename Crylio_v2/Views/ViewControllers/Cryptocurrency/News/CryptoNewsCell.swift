//
//  CryptoOrderCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 30/03/2021.
//

import UIKit
import Kingfisher


class CryptoNewsCell: UITableViewCell {
    
    static let reuseId = "FeedCell"
    
    lazy var contentBox = RoundShadowView()
    lazy var typeImageBox = RoundShadowView()
    lazy var typeImageView = UIImageView()
    lazy var autorLabel = UILabel()
    lazy var separatorView = CircleView()
    lazy var timeLabel = UILabel()
    lazy var moreButton = UIButton()
    lazy var titleLabel = UILabel()
    lazy var newsImageView = UIImageView()
    
    var news: News! {
        didSet {
            initValues()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentBox.backgroundColor = AppColors.background.primary
        contentBox.layer.cornerRadius = 14
        
        typeImageBox.layer.cornerRadius = 4
        typeImageBox.backgroundColor = AppColors.background.secondary
        
        autorLabel.font = .systemFont(ofSize: 15, weight: .regular)
        autorLabel.textColor = AppColors.label.secondary
        
        separatorView.backgroundColor = AppColors.label.secondary
        
        timeLabel.font = .systemFont(ofSize: 15)
        timeLabel.textColor = AppColors.label.secondary
        
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        titleLabel.numberOfLines = 0
        
        newsImageView.clipsToBounds = true
        newsImageView.backgroundColor = AppColors.background.tertiary
        newsImageView.contentMode = .scaleAspectFill
        
        let moreIcon = UIImage(named: "moreIcon")?.withRenderingMode(.alwaysTemplate)
        moreButton.setImage(moreIcon, for: .normal)
        moreButton.tintColor = AppColors.label.secondary
        
        configureGestureRecognizer()
        
        contentView.addSubview(contentBox)
        contentBox.addSubview(typeImageBox)
        typeImageBox.addSubview(typeImageView)
        contentBox.addSubview(autorLabel)
        contentBox.addSubview(separatorView)
        contentBox.addSubview(timeLabel)
        contentBox.addSubview(moreButton)
        contentBox.addSubview(titleLabel)
        contentBox.addSubview(newsImageView)
    }
    
    func initValues() {
        
        typeImageView.image = UIImage(named: news.type.rawValue + "Icon")?.withRenderingMode(.alwaysTemplate)
        titleLabel.text = news.title
        autorLabel.text = news.autor
        timeLabel.text = news.time.timeAgoDisplay()
        
        if news.type == .web {
            typeImageView.tintColor = AppColors.label.primary
            titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        }
        
        if let url =  news.imageURL {
            DispatchQueue.main.async { self.newsImageView.setImage(from: url) }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImageView.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius: 14)
    }
}


// MARK: Gesture recognizer

extension CryptoNewsCell {
    
    private func configureGestureRecognizer() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tap)
    }
    
    @objc internal func handleTapGesture(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        animate()
    }
    
    private func animate() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
        })
        
        UIView.animate(withDuration: 0.2, delay: 0.2, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.transform = CGAffineTransform.identity
        })
    }
    
}


// MARK: - Constraints

extension CryptoNewsCell {
    
    override func layoutIfNeeded() {
        
        contentBox.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalTo(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        if news.imageURL != nil {
            
            newsImageView.snp.makeConstraints { make in
                make.left.equalToSuperview()
                make.right.equalToSuperview()
                make.top.equalToSuperview()
                make.height.equalTo(200)
            }
            
            typeImageBox.snp.makeConstraints { make in
                make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
                make.top.equalTo(newsImageView.snp.bottom).offset(10)
                make.width.height.equalTo(25)
            }
        } else {
            
            typeImageBox.snp.makeConstraints { make in
                make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
                make.top.equalTo(CONTENT_TOP_MARGIN)
                make.width.height.equalTo(25)
            }
        }
        
        typeImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(17)
        }
        
        autorLabel.snp.makeConstraints { make in
            make.left.equalTo(typeImageBox.snp.right).offset(10)
            make.centerY.equalTo(typeImageBox)
            make.width.equalTo(autorLabel.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
        
        separatorView.snp.makeConstraints { make in
            make.left.equalTo(autorLabel.snp.right).offset(5)
            make.centerY.equalTo(typeImageBox)
            make.width.height.equalTo(3)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(separatorView.snp.right).offset(5)
            make.centerY.equalTo(typeImageBox)
            make.width.equalTo(timeLabel.intrinsicContentSize.width)
            make.height.equalTo(16)
        }
        
        moreButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(typeImageBox)
            make.width.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(typeImageBox.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN).priority(999)
        }
        
        super.layoutIfNeeded()
    }
    
}

