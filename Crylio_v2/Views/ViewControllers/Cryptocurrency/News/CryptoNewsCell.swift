//
//  CryptoOrderCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 30/03/2021.
//

import UIKit
import Kingfisher


class CryptoNewsCell: UITableViewCell, UITextViewDelegate {
    
    static let reuseId = "FeedCell"
    
    lazy var contentBox = BackgroundBoxView()
    lazy var typeImageBox = UIView()
    lazy var typeImageView = UIImageView()
    lazy var autorLabel = UILabel()
    lazy var separatorView = CircleView()
    lazy var timeLabel = UILabel()
    lazy var moreButton = UIButton()
    lazy var textView = UITextView()
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
                
        typeImageBox.layer.cornerRadius = 4
        typeImageBox.backgroundColor = AppColors.background.primary
        
        autorLabel.font = .systemFont(ofSize: 15, weight: .medium)
        autorLabel.textColor = AppColors.label.secondary
        
        separatorView.backgroundColor = AppColors.label.secondary
        
        timeLabel.font = .systemFont(ofSize: 15)
        timeLabel.textColor = AppColors.label.secondary
        
        textView.font = .systemFont(ofSize: 17, weight: .semibold)
        textView.isSelectable = true
        textView.isEditable = false
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = true
        textView.isScrollEnabled = false
        textView.sizeToFit()
        textView.backgroundColor = .clear
        
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
        contentBox.addSubview(textView)
        contentBox.addSubview(newsImageView)
    }
    
    func initValues() {
        
        typeImageView.image = UIImage(named: news.type.rawValue + "Icon")?.withRenderingMode(.alwaysTemplate)
        setCellText(text: news.title)
        autorLabel.text = news.autor
        timeLabel.text = news.time.timeAgoDisplay()
        
        if news.type == .web {
            typeImageView.tintColor = AppColors.label.primary
            textView.font = .systemFont(ofSize: 17, weight: .bold)
        }
        
        if let url =  news.imageURL {
            DispatchQueue.main.async { self.newsImageView.setImage(from: url) }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsImageView.roundCorners(corners: [UIRectCorner.topLeft, UIRectCorner.topRight], radius: contentBox.layer.cornerRadius)
    }
    
}


// MARK: Text view delegate

extension CryptoNewsCell {
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        textView.selectedTextRange = nil
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        // check for our fake URL scheme hash:helloWorld
        switch URL.scheme {
        case "hash" :
            print("tapped hashtag.")
        case "mention" :
            print("tapped mention.")
        default:
            print("just a regular url")
        }
        
        return true
    }
    
    func setCellText(text: String) {
        
        textView.text = text
        textView.resolveHashTags()
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
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
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
        
        textView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(typeImageBox.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(CONTENT_BOTTOM_MARGIN).priority(999)
        }
        
        super.layoutIfNeeded()
    }
    
}

