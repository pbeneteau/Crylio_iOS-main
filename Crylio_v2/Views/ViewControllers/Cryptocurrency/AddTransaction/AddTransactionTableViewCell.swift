//
//  AddTransactionTableViewCell.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 25/05/2021.
//

import UIKit

class AddTransactionTableViewCell: UITableViewCell {
    
    static let reuseId = "AddTransactionTableViewCell"
    
    lazy var textField = BaseInputView()
    lazy var prefixSuffixLabel = UILabel()
    
    lazy var enteredValue = ""
    
    var input: UserInput! {
        didSet {
            initValues()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    convenience init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, crypto: Cryptocurrency) {
        self.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
        initValues()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
                        
        selectionStyle = .none
        
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(textField)
    }

    
    private func initValues() {
        
        if input.suggestions != nil {
            textField = SearchUserInputView(input: input)
        } else {
            textField = UserInputView(input: input)
        }
        
        contentView.addSubview(textField)
    }
      
}


// MARK: - Constraints

extension AddTransactionTableViewCell {
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
                
        textField.snp.makeConstraints { make in
            make.left.centerY.right.equalToSuperview()
            make.height.equalTo(55)
        }
    }
}


