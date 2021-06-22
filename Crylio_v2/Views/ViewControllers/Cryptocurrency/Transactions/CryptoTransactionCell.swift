//
//  CryptoTransactionsCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 22/03/2021.
//

import UIKit


class CryptoTransactionCell: BaseTableViewCell {
    
    static let reuseId = "CryptoTransactionCell"
    
    lazy var backgroundBox = BackgroundBoxView()
    lazy var cellView = TransactionCellView()
    lazy var detailView = TransactionCellDetailView()
    
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
        
        contentView.clipsToBounds = true
        
        detailView.alpha = 0
        
        backgroundBox.layer.cornerRadius = 10
        backgroundBox.insets = UIEdgeInsets(top: 10, left: SAFE_AREA_MARGIN, bottom: 10, right: SAFE_AREA_MARGIN)
        backgroundBox.blur = 10
        
        detailView.alpha = 1
        detailView.addTopBorder()
        
        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        cellView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(backgroundBox)
        backgroundBox.addSubview(cellView)
        
        backgroundBox.addSubview(detailView)
        
        setNeedsUpdateConstraints()
    }
    
    private func initValues() {
        
        cellView.transaction = transaction
        
        if !(transaction.type == .transferIn || transaction.type == .transferOut) {
            detailView.transaction = transaction
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
    
    // MARK: - Constraints
    
    override func makeConstraints() {
                
        backgroundBox.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().priority(999)
            make.bottom.equalToSuperview()
            make.height.equalTo(116).priority(999)
        }
        
        cellView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(116-20)
        }
        
        if !(transaction.type == .transferIn || transaction.type == .transferOut) {
            
            detailView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
                make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
                make.top.equalTo(cellView.snp.bottom)
                make.bottom.equalToSuperview().inset(10)
            }
        }
    }
    
}


extension CryptoTransactionCell {
    
    var isDetailViewHidden: Bool {
        return detailView.isHidden
    }
    
    func showDetailView() {
        
        self.backgroundBox.snp.remakeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview().priority(999)
            make.bottom.equalToSuperview()
            make.height.equalTo(273).priority(999)
        }
        
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseOut], animations: {
            self.layoutSubviews()
        })
        
        UIView.animate(withDuration: 0.15, delay: 0.15, options: [.curveEaseOut], animations: {
            self.detailView.alpha = 1
        })
        
    }
    
    func hideDetailView() {
        
        self.backgroundBox.snp.updateConstraints { make in
            make.height.equalTo(116).priority(999)
        }
        UIView.animate(withDuration: 0.15, delay: 0.0, options: [.curveEaseOut], animations: {
            self.layoutSubviews()
            self.detailView.alpha = 0
        })
    }
    
}


