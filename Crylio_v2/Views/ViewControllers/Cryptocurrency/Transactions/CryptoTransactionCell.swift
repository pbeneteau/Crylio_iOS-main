//
//  CryptoTransactionsCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 22/03/2021.
//

import UIKit



class CryptoTransactionCell: UITableViewCell {
    
    static let reuseId = "TransactionCell"

    let bgView = UIView()
    
    lazy var transactionTypeCircleView = CircleView()
    lazy var transactionTypeLabel = UILabel()
    lazy var amountLabel = UILabel()
    lazy var exchangeLabel = UILabel()
    lazy var worthLabel = UILabel()
    lazy var dateLabel = UILabel()
    lazy var filledStatusBoxView = RoundShadowView()
    lazy var filledStatusLabel = UILabel()
        
    var transaction: Transaction! {
        didSet {
            
            initValues()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    
    private func commonInit() {
        
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        bgView.backgroundColor = AppColors.background.secondary
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.layer.masksToBounds = true
        bgView.layer.cornerRadius = 7
        
        transactionTypeLabel.font = .systemFont(ofSize: 17)
        
        exchangeLabel.font = .systemFont(ofSize: 15)
        exchangeLabel.textColor = .systemGray
        
        amountLabel.textAlignment = .right
        amountLabel.font = .systemFont(ofSize: 13)
        
        dateLabel.textColor = .systemGray
        dateLabel.font = .systemFont(ofSize: 13)
        
        worthLabel.textAlignment = .right
        worthLabel.font = .systemFont(ofSize: 15, weight: .medium)
        
        filledStatusBoxView.layer.cornerRadius = 3
        filledStatusBoxView.backgroundColor = .systemGreen
        filledStatusBoxView.alpha = 0.15
        
        filledStatusLabel.textAlignment = .center
        filledStatusLabel.font = .systemFont(ofSize: 13)
        filledStatusLabel.textColor = .systemGreen
                
        contentView.addSubview(bgView)
        bgView.addSubview(transactionTypeCircleView)
        bgView.addSubview(transactionTypeLabel)
        bgView.addSubview(amountLabel)
        bgView.addSubview(exchangeLabel)
        bgView.addSubview(worthLabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(filledStatusBoxView)
        bgView.addSubview(filledStatusLabel)
    }
    
    func initValues() {
        
        transactionTypeLabel.text = transaction.transactionType.rawValue
        filledStatusLabel.text = transaction.status.rawValue
        
        exchangeLabel.text =  "via " + transaction.exchange
        if transaction.transactionType == .transferOut || transaction.transactionType == .transferIn {
            exchangeLabel.text = "to " + transaction.exchange
        }
        exchangeLabel.setSpannedColor(fullText:  exchangeLabel.text!, changeText: transaction.exchange, color: .label)

        worthLabel.setDollarMutableString(value: transaction.worth)
        
        amountLabel.text = transaction.amount.toAmountString() + "/" + transaction.amountExecuted.toAmountString()
        amountLabel.setSpannedColor(fullText: transaction.amount.toAmountString(), changeText: "/" + transaction.amountExecuted.toAmountString(), color: .systemGray)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/YY HH:MM:ss"
        dateLabel.text = dateFormatter.string(from: transaction.time)

        
        switch transaction.transactionType {
        case .marketSell:
            transactionTypeCircleView.backgroundColor = .systemRed
        case .marketBuy:
            transactionTypeCircleView.backgroundColor = .systemGreen
        case .limitBuy:
            transactionTypeCircleView.backgroundColor = .systemGreen
        case .limitSell:
            transactionTypeCircleView.backgroundColor = .systemRed
        case .transferIn:
            transactionTypeCircleView.backgroundColor = .systemBlue
        case .transferOut:
            transactionTypeCircleView.backgroundColor = .systemBlue
        }
        
        switch transaction.status {
        case .filled:
            filledStatusBoxView.backgroundColor = .systemGreen
            filledStatusLabel.textColor = .systemGreen
        case .transfered:
            filledStatusBoxView.backgroundColor = .systemGray
            filledStatusLabel.textColor = .systemGray
        case .canceled:
            filledStatusBoxView.backgroundColor = .systemRed
            filledStatusLabel.textColor = .systemRed
        default:
            filledStatusBoxView.backgroundColor = .systemGray
            filledStatusLabel.textColor = .systemGray
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        
        filledStatusBoxView.snp.remakeConstraints { make in
            make.right.equalToSuperview().offset(-16)
            make.centerY.equalTo(transactionTypeLabel)
            make.width.equalTo(filledStatusLabel.intrinsicContentSize.width + 8)
            make.height.equalTo(20)
        }
    }
}


// MARK: - Constraints

extension CryptoTransactionCell {
    
    override func layoutIfNeeded() {
        
        bgView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.bottom.equalToSuperview()
        }
        
        transactionTypeCircleView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.top.equalToSuperview().offset(CONTENT_TOP_MARGIN)
            make.height.width.equalTo(8)
        }
        
        transactionTypeLabel.snp.makeConstraints { make in
            make.left.equalTo(transactionTypeCircleView.snp.right).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(transactionTypeCircleView)
            make.height.equalTo(20)
        }
        
        exchangeLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalTo(snp.centerX).inset(8)
            make.top.equalTo(transactionTypeLabel.snp.bottom).offset(9)
            make.height.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalTo(snp.centerX).inset(8)
            make.top.equalTo(exchangeLabel.snp.bottom).offset(4)
            make.height.equalTo(16)
        }
        
        filledStatusBoxView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(transactionTypeLabel)
            make.width.equalTo(filledStatusLabel.intrinsicContentSize.width + 8)
            make.height.equalTo(20)
        }
        
        filledStatusLabel.snp.makeConstraints { make in
            make.center.equalTo(filledStatusBoxView)
            make.height.width.equalTo(filledStatusBoxView)
        }
        
        worthLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(exchangeLabel)
            make.height.equalTo(18)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(8)
            make.right.equalToSuperview().inset(CONTENT_HORIZONTAL_MARGIN)
            make.centerY.equalTo(dateLabel)
            make.height.equalTo(16)
        }
        
        super.layoutIfNeeded()
    }
    
}
