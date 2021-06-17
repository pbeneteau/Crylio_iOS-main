//
//  CryptoTransactionsCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 22/03/2021.
//

import UIKit


class CryptoTransactionCell: UITableViewCell {
    
    static let reuseId = "CryptoTransactionCell"

    lazy var backgroundBox = RoundShadowView()
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
        
        backgroundBox.layer.cornerRadius = 10
        
        detailView.alpha = 0
        
        backgroundBox.translatesAutoresizingMaskIntoConstraints = false
        cellView.translatesAutoresizingMaskIntoConstraints = false
        detailView.translatesAutoresizingMaskIntoConstraints = false
                
        contentView.addSubview(backgroundBox)
        backgroundBox.addSubview(cellView)
        backgroundBox.addSubview(detailView)
    }
    
    private func initValues() {
        
        cellView.transaction = transaction
        detailView.transaction = transaction
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension CryptoTransactionCell {
    
    var isDetailViewHidden: Bool {
        return detailView.isHidden
    }

    func showDetailView() {
        
        UIView.animate(withDuration: 0.2,delay: 0.2, animations: {
            self.detailView.alpha = 1
        })
        
        backgroundBox.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalToSuperview().priority(999)
            make.bottom.equalToSuperview().inset(16).priority(999)
            make.height.equalTo(206+16).priority(999)
        }
        
        self.layoutIfNeeded()
    }

    func hideDetailView() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            self.detailView.alpha = 0
            
            self.backgroundBox.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
                make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
                make.top.equalToSuperview().priority(999)
                make.bottom.equalToSuperview().inset(16).priority(999)
                make.height.equalTo(112-16).priority(999)
            }
            
            self.layoutIfNeeded()
        })
    }
}


// MARK: - Constraints

extension CryptoTransactionCell {
    
    override func updateConstraints() {
                
        backgroundBox.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.top.equalToSuperview().priority(999)
            make.bottom.equalToSuperview().inset(16).priority(999)
            make.height.equalTo(112-16).priority(999)
        }
        
        cellView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(112-16)
        }

        detailView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(cellView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        super.updateConstraints()
    }
    
}
