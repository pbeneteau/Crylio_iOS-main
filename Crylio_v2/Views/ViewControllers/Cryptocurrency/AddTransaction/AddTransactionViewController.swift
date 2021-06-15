//
//  AddTransactionViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 25/05/2021.
//

import UIKit


class AddTransactionViewController: UIViewController {
    
    lazy var titleView = UIView()
    lazy var iconImageView = UIImageView()
    lazy var titleLabel = UILabel()
    
    lazy var transactionTypePicker = UISegmentedControl(items: ["Buy", "Sell", "Transfer"])
    
    lazy var costField = UITextField()
    lazy var pairButton = UIButton()
    lazy var amountLabel = UILabel()
    
    var costInput = String()
    var priceInput = String()
    
    lazy var priceField = UserInputView()
    lazy var datePicker = UIDatePicker()
    lazy var feeField = UserInputView()
    lazy var transferTypePicker = UISegmentedControl(items: ["Transfer in", "Transfer out"])
    lazy var addTransactionButton = RoundCornersButton()
    
    var keyboardHeight: CGFloat = 0.0
        
    private var inputs = [UserInput]()
    
    var crypto: Cryptocurrency! {
        didSet {
            updateValues()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.backgroundColor = AppColors.background.primary
        
        navigationItem.titleView = titleView
        titleView.sizeToFit()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        
        transactionTypePicker.selectedSegmentIndex = 0
        transactionTypePicker.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        
        costField.textAlignment = .center
        costField.font = .systemFont(ofSize: 54, weight: .bold)
        costField.placeholder = "0"
        costField.keyboardType = .decimalPad
        costField.addTarget(self, action: #selector(textDidBeginEditing(_:)), for: .editingDidBegin)
        costField.adjustsFontSizeToFitWidth = true
        costField.becomeFirstResponder()
        costField.tag = 1
        costField.delegate = self

        amountLabel.font = .systemFont(ofSize: 20, weight: .semibold)
        amountLabel.textColor = AppColors.label.tertiary
        amountLabel.textAlignment = .center
        amountLabel.text = "~0 " + crypto.symbol.uppercased()
        amountLabel.adjustsFontSizeToFitWidth = true
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        pairButton.setTitle("USDT", for: .normal)
        pairButton.setTitleColor(AppColors.label.secondary, for: .normal)
        pairButton.titleLabel?.font = .systemFont(ofSize: 24, weight: .medium)
        let swapIcon = UIImage(named: "swapIcon")?.withRenderingMode(.alwaysTemplate)
        pairButton.setImage(swapIcon, for: .normal)
        pairButton.tintColor = AppColors.label.secondary
        pairButton.semanticContentAttribute = .forceRightToLeft
        pairButton.addTarget(self, action: #selector(didTapPairSwapButton(_:)), for: .touchUpInside)
        pairButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        
        priceField.input = UserInput(type: .price, title: "Price per coin", placeholder: "0", value: Float(39402).toAmountString(), affix: UserInput.Affix(type: .suffix, string: "USDT"))
        priceField.tag = 2
        priceField.textField.delegate = self
        priceInput = "39402"
        
        feeField.input = UserInput(type: .price, title: "Fee", placeholder: "0", affix: UserInput.Affix(type: .suffix, string: "USDT"))
        
        transferTypePicker.selectedSegmentIndex = 0
        transferTypePicker.alpha = 0
        
        addTransactionButton.cornerRadius = 10
        addTransactionButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        addTransactionButton.backgroundColor = .systemBlue
        addTransactionButton.setTitle("Add Transaction", for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        titleView.addSubview(iconImageView)
        titleView.addSubview(titleLabel)
        view.addSubview(transactionTypePicker)
        view.addSubview(costField)
        view.addSubview(amountLabel)
        view.addSubview(pairButton)
        view.addSubview(priceField)
        view.addSubview(datePicker)
        view.addSubview(feeField)
        view.addSubview(transferTypePicker)
        view.addSubview(addTransactionButton)
        view.bringSubviewToFront(addTransactionButton)
    }
    
    private func updateValues() {
        
        titleLabel.text = crypto.name
        iconImageView.setImage(from: crypto.iconURL)
        priceField.textField.text = crypto.price.toDollarString()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            setBuySellMode()
        case 1:
            setBuySellMode()
        case 2:
            setTransferMode()
        default: return
        }
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
                
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            self.keyboardHeight = keyboardHeight
            viewWillLayoutSubviews()
        }
    }
    
    @objc func didTapPairSwapButton(_ sender: UIButton) {
        
        print("selecting trading pair...")
                
        let controller = SelectCryptoViewController()
        controller.title = "Select Trading Pair"
        controller.cryptos = [crypto, crypto, crypto, crypto, crypto]
        controller.selectionDelegate = self
        
        navigationController?.pushViewController(controller, animated: true)
    }
        
    private func setBuySellMode() {
        
        pairButton.isEnabled = true
        costField.text = ""
        amountLabel.text = "~0 " + crypto.symbol.uppercased()
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.pairButton.imageView?.alpha = 1
            self.priceField.alpha = 1
            self.transferTypePicker.alpha = 0
            self.priceField.transform = .identity
            self.transferTypePicker.transform = .identity
        })
    }
    
    private func setTransferMode() {
        
        costInput = ""
        pairButton.setTitle(crypto.symbol.uppercased(), for: .normal)
        pairButton.isEnabled = false
        costField.text = ""
        amountLabel.text = "~0 USD"
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.beginFromCurrentState, .curveEaseInOut], animations: {
            self.pairButton.imageView?.alpha = 0
            self.priceField.alpha = 0
            self.transferTypePicker.alpha = 1
            self.priceField.transform = CGAffineTransform(translationX: -20, y: 0)
            self.transferTypePicker.transform = CGAffineTransform(translationX: -20, y: 0)
        })
    }
   
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        addTransactionButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardHeight+20)
        }
    }
}


// MARK: - Trading pair selection delegate

extension AddTransactionViewController: SelectCryptoViewControllerDegate {
    
    func didSelectCrypto(_ crypto: Cryptocurrency) {
        
        print("did select", crypto.name, "as a trading pair")

        pairButton.setTitle(crypto.symbol.uppercased(), for: .normal)
        priceField.textField.text = crypto.price.toAmountString()
    }
}


// MARK: - Text field delegate

extension AddTransactionViewController: UITextFieldDelegate {
    
    @objc private func textDidChange(_ textField: UITextField) {
        
        updateAmountLabel()
        
        if textField.tag == 1 {
            if costField.intrinsicContentSize.width + pairButton.frame.width + 5 > view.frame.width - SAFE_AREA_MARGIN*6 {
                return
            }
            costField.snp.updateConstraints { make in
                make.width.equalTo(costField.intrinsicContentSize.width+10)
            }
            view.layoutIfNeeded()
        }
    }
    
    @objc private func textDidBeginEditing(_ textField: UITextField) {
        
        DispatchQueue.main.async {
            let newPosition = textField.endOfDocument
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let string = string.replacingOccurrences(of: ",", with: ".")
        
        if textField.tag == 1 {
            if string == "." && costInput.contains(string) {
                return false
            }
            switch string {
              case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                costInput.append(string)
            case ".":
                costInput.append(string)
                costField.text?.append(",")
                textDidChange(textField)
                return false
              default:
                  if costInput.count > 0 {
                    costInput.removeLast()
                  }
              }
            if let cost = Float(costInput) {
                costField.text = cost.toAmountString()
            } else if costInput.count == 0 {
                costField.text = ""
            }
        } else {
            if string == "." && priceInput.contains(string) {
                return false
            }
            switch string {
              case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
                priceInput.append(string)
            case ".":
                priceInput.append(string)
                priceField.textField.text?.append(",")
                textDidChange(textField)
                return false
              default:
                  if priceInput.count > 0 {
                    priceInput.removeLast()
                  }
              }
            if let price = Float(priceInput) {
                priceField.textField.text = price.toAmountString()
            } else if priceInput.count == 0 {
                priceField.textField.text = ""
            }
        }
        
        textDidChange(textField)
        
        return false
    }
    
    private func updateAmountLabel() {
        
        if transactionTypePicker.selectedSegmentIndex != 2 {
            if let cost = Float(costInput) {
                if let price = Float(priceInput) {
                    let amount = cost / price
                    amountLabel.text = "~" + amount.toAmountString() + " \(crypto.symbol.uppercased())"
                }
            } else {
                amountLabel.text = "~0 " + crypto.symbol.uppercased()
            }
        } else {
            if let cost = Float(costInput) {
                let amount = crypto.price * cost
                amountLabel.text = "~" + amount.toAmountString() + " USD"
            } else {
                amountLabel.text = "~0 USD"
            }
        }
    }
    
}


// MARK: - Constraints

extension AddTransactionViewController {
    
    override func updateViewConstraints() {
                
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.width.equalTo(titleLabel.intrinsicContentSize.width+10)
            make.height.equalTo(20)
        }

        transactionTypePicker.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.top.equalTo(90)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(40)
        }
        
        costField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(transactionTypePicker.snp.bottom).offset(70)
            make.width.equalTo(costField.intrinsicContentSize.width+10)
            make.height.equalTo(64)
        }
        
        pairButton.snp.makeConstraints { make in
            make.left.equalTo(costField.snp.right)
            make.centerY.equalTo(costField).offset(10)
            make.width.equalTo(pairButton.intrinsicContentSize.width)
            make.height.equalTo(29)
        }
        
        amountLabel.snp.makeConstraints { make in
            make.top.equalTo(costField.snp.bottom).offset(15)
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(26)
        }
        
        addTransactionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.bottom.equalToSuperview().inset(310).priority(999)
            make.right.equalToSuperview().offset(-SAFE_AREA_MARGIN)
            make.height.equalTo(50)
        }
        
        datePicker.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(view.snp.centerX).offset(-8)
            make.bottom.equalTo(addTransactionButton.snp.top).offset(-16)
            make.height.equalTo(34)
        }
        
        feeField.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(8)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.bottom.equalTo(addTransactionButton.snp.top).offset(-16)
            make.height.equalTo(34)
        }
        
        priceField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(datePicker.snp.top).offset(-16)
            make.width.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(34)
        }
        
        transferTypePicker.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-SAFE_AREA_MARGIN+20)
            make.bottom.equalTo(feeField.snp.top).offset(-16)
            make.width.equalTo(feeField)
            make.height.equalTo(34)
        }
        
        super.updateViewConstraints()
    }
}
