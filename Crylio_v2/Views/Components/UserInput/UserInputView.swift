//
//  UserInputView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 27/05/2021.
//

import UIKit



struct UserInput {
    
    var type: InputType
    var title: String
    var placeholder: String
    var value: String?
    var suggestions: [SearchTextFieldItem]?
    var affix: Affix?
    
    struct Affix {
        
        var type: _Type
        var string: String
        
        enum _Type {
            case prefix
            case suffix
        }
    }
    
    enum InputType {
        
        case text
        case alphabetOnly
        case amount
        case price
        case date
        case multipleChoicePrice
    }
    
    func getKeyboardType() -> UIKeyboardType {
        
        switch type {
        case .amount: return .decimalPad
        case .date: return .default
        case .multipleChoicePrice: return .decimalPad
        case .price: return .decimalPad
        case .text: return .default
        case .alphabetOnly: return .alphabet
        }
    }
}


class BaseInputView: UIView {
    
    var didUpdateConstraints = false
    
    lazy var backgroundView = UIView()
    lazy var titleLabel = UILabel()
    lazy var affixLabel = UILabel()
    
    var input: UserInput! {
        didSet {
            initValues()
        }
    }
    
    var isInputValid = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    convenience init(input: UserInput) {
        self.init(frame: CGRect.zero)
        
        self.input = input
        
        initValues()
        commonInit()
    }
    
    func initValues() {
        
        titleLabel.text = input.title
        if let affix = input.affix {
            affixLabel.text = affix.string
        }
    }
    
    func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        
        backgroundView.backgroundColor = AppColors.background.tertiary
        backgroundView.layer.cornerRadius = 7
        backgroundView.clipsToBounds = true
        
        affixLabel.textAlignment = .left
        affixLabel.textColor = AppColors.label.secondary
        
        titleLabel.textColor = AppColors.label.secondary
        titleLabel.font = .systemFont(ofSize: 15)
        
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(affixLabel)
    }
    
}


class UserInputView: BaseInputView {
    
    lazy var textField = BaseTextField()
    
    var textFieldValue = String()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initValues() {
        super.initValues()
        
        textField.placeholder = input.placeholder
        if let value = input.value {
            textField.text = value
        }
        
        textField.keyboardType = input.getKeyboardType()
    }
    
    override func commonInit() {
        super.commonInit()
        
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .right
        textField.textColor = AppColors.label.primary
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        addSubview(textField)
        bringSubviewToFront(textField)
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        
        if input.affix?.type == .prefix {
            affixLabel.snp.updateConstraints { make in
                make.right.equalTo(textField).inset(textField.intrinsicContentSize.width)
            }
        }
        
        isInputValid = true
        self.textField.setSelectionValid(true)
        
        if let inputString = textField.text {
            if !checkInputValidity(of: inputString.replacingOccurrences(of: ",", with: "."), inputType: input.type) {
                isInputValid = false
                self.textField.setSelectionValid(false)
            }
        }
    }
    
    // MARK: - Constraints
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !didUpdateConstraints {
            
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(13)
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(titleLabel.intrinsicContentSize.width)
            }
            
            if let type = input.affix?.type, type == .suffix {
                
                affixLabel.snp.makeConstraints { make in
                    make.right.equalToSuperview().inset(13)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(affixLabel.intrinsicContentSize.width)
                    make.height.equalToSuperview()
                }
                
                textField.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(16)
                    make.right.equalTo(affixLabel.snp.left).offset(-5)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
                
            } else if let type = input.affix?.type, type == .prefix {
                
                textField.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(16)
                    make.right.equalToSuperview().inset(13)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
                
                affixLabel.snp.makeConstraints { make in
                    make.right.equalTo(textField).inset(textField.intrinsicContentSize.width+5)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(affixLabel.intrinsicContentSize.width)
                    make.height.equalToSuperview()
                }
            } else {
                
                textField.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(16)
                    make.right.equalToSuperview().inset(13)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
            }
            didUpdateConstraints = true
        }
    }
}


class SearchUserInputView: BaseInputView {
    
    lazy var textField = SearchTextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func initValues() {
        super.initValues()
        
        textField.placeholder = input.placeholder
        if let suggestions = input.suggestions {
            textField.filterItems(suggestions)
        }
        
        if let value = input.value {
            textField.text = value
        }
        
        textField.keyboardType = input.getKeyboardType()
    }
    
    override func commonInit() {
        super.commonInit()
        
        textField.backgroundColor = .clear
        textField.font = .systemFont(ofSize: 17)
        textField.textAlignment = .right
        textField.textColor = AppColors.label.primary
        
        textField.theme = traitCollection.userInterfaceStyle == .dark ? SearchTextFieldTheme.darkTheme(): SearchTextFieldTheme.lightTheme()
        textField.theme.font = .systemFont(ofSize: 17)
        textField.theme.bgColor = .clear
        textField.theme.cellHeight = 45
        textField.highlightAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 17)]
        textField.theme.borderWidth = 0
        textField.theme.borderColor = .clear
        textField.spellCheckingType = .no
        textField.autocorrectionType = .no
        
        // Define a results list header
        let header = SearchTextFieldSuggestionsHeader(frame: CGRect(x: 0, y: 0, width: textField.frame.width, height: 38))
        header.title.text = "Suggestions"
        textField.resultsListHeader = header
        
        textField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        
        addSubview(textField)
        bringSubviewToFront(textField)
    }
    
    @objc private func textDidChange(_ textField: UITextField) {
        
        if input.affix?.type == .prefix {
            affixLabel.snp.updateConstraints { make in
                make.right.equalTo(textField).inset(textField.intrinsicContentSize.width+5)
            }
        }
        
        self.isInputValid = true
        self.textField.setSelectionValid(true)
        
        if let inputString = textField.text {
            if !checkInputValidity(of: inputString, inputType: input.type) {
                isInputValid = false
                self.textField.setSelectionValid(false)
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !didUpdateConstraints {
            
            backgroundView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            titleLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().offset(13)
                make.centerY.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(titleLabel.intrinsicContentSize.width)
            }
            
            if let type = input.affix?.type, type == .suffix {
                
                affixLabel.snp.makeConstraints { make in
                    make.right.equalToSuperview().inset(13)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(affixLabel.intrinsicContentSize.width)
                    make.height.equalToSuperview()
                }
                
                textField.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(16)
                    make.right.equalTo(affixLabel.snp.left).offset(-5)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
                
            } else if let type = input.affix?.type, type == .prefix {
                
                textField.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(16)
                    make.right.equalToSuperview().inset(13)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
                
                affixLabel.snp.makeConstraints { make in
                    make.right.equalTo(textField).inset(textField.intrinsicContentSize.width+5)
                    make.centerY.equalToSuperview()
                    make.width.equalTo(affixLabel.intrinsicContentSize.width)
                    make.height.equalToSuperview()
                }
            } else {
                
                textField.snp.makeConstraints { make in
                    make.left.equalTo(titleLabel.snp.right).offset(16)
                    make.right.equalToSuperview().inset(13)
                    make.centerY.equalToSuperview()
                    make.height.equalToSuperview()
                }
            }
            didUpdateConstraints = true
        }
    }
}
