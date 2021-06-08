//
//  AddTransactionViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 25/05/2021.
//

import UIKit


class AddTransactionViewController: UIViewController {
    
    lazy var titleLabel = UILabel()
    lazy var transactionTypePicker = UISegmentedControl(items: ["Long", "short", "Transfer"])
    lazy var tableView = UITableView()
    lazy var addTransactionButton = RoundCornersButton()
    lazy var cancelButton = UIButton()
    
    private var inputs = [UserInput]()
    
    var crypto: Cryptocurrency! {
        didSet {
            updateValues()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(cancelButtonTapped(_:)))
        
        view.backgroundColor = AppColors.background.primary
        
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(.systemBlue, for: .normal)
        
        transactionTypePicker.selectedSegmentTintColor = .systemGreen
        transactionTypePicker.selectedSegmentIndex = 0
        transactionTypePicker.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        transactionTypePicker.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        transactionTypePicker.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: AppColors.label.secondary], for: .normal)
        
        tableView.backgroundColor = AppColors.background.primary
        tableView.register(AddTransactionTableViewCell.self, forCellReuseIdentifier: AddTransactionTableViewCell.reuseId)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
        addTransactionButton.cornerRadius = 10
        addTransactionButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        addTransactionButton.backgroundColor = .systemBlue
        addTransactionButton.setTitle("Add Transaction", for: .normal)
        
        inputs.append(UserInput(type: .alphabetOnly,
                                title: "Exchange",
                                placeholder: "Binance",
                                suggestions: [SearchTextFieldItem(title: "Binance", subtitle: "", image: UIImage(named: "binance")),
                                              SearchTextFieldItem(title: "Bitfinex", subtitle: "", image: UIImage(named: "bitfinex")),
                                              SearchTextFieldItem(title: "Bittrex", subtitle: "", image: UIImage(named: "bittrex"))]))
        inputs.append(UserInput(type: .alphabetOnly,
                                title: "Pair",
                                placeholder: "USDT",
                                value: "USDT",
                                suggestions: [SearchTextFieldItem(title: "USDT")],
                                affix: UserInput.Affix(type: .prefix, string: "BTC /")))
        inputs.append(UserInput(type: .price,
                                title: "Per coin",
                                placeholder: String(0),
                                affix: UserInput.Affix(type: .suffix, string: inputs[1].value ?? "")))
        inputs.append(UserInput(type: .amount,
                                title: "Quantity",
                                placeholder: String(0),
                                affix: UserInput.Affix(type: .suffix, string: "BTC")))
        inputs.append(UserInput(type: .price,
                                title: "Fees",
                                placeholder: String(0),
                                affix: UserInput.Affix(type: .suffix, string: inputs[1].value ?? "")))
        inputs.append(UserInput(type: .date,
                                title: "Date",
                                placeholder: "23 May, 2021",
                                value: "23 May, 2021"))
        
        updateValues()
        
        view.addSubview(titleLabel)
        view.addSubview(cancelButton)
        view.addSubview(transactionTypePicker)
        view.addSubview(tableView)
        view.addSubview(addTransactionButton)
        view.bringSubviewToFront(addTransactionButton)
    }
    
    private func updateValues() {
        
        titleLabel.text = "Add XRP Transaction"
        tableView.reloadData()
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0: sender.selectedSegmentTintColor = .systemGreen
        case 1: sender.selectedSegmentTintColor = .systemRed
        case 2: sender.selectedSegmentTintColor = .systemGray
        default:
            return
        }
    }
    
    @objc private func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
}


// MARK: - Table view delegate and datasource

extension AddTransactionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AddTransactionTableViewCell.reuseId, for: indexPath) as? AddTransactionTableViewCell  else {
            fatalError("The dequeued cell is not an instance of AddTransactionTableViewCell.")
        }
        
        cell.input = inputs[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}


// MARK: - Constraints

extension AddTransactionViewController {
    
    override func updateViewConstraints() {
        
        cancelButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.top.equalToSuperview().offset(20)
            make.height.equalTo(20)
            make.width.equalTo(cancelButton.intrinsicContentSize.width)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(cancelButton.snp.right).offset(8)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(20)
        }
        
        transactionTypePicker.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.top.equalTo(90)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.height.equalTo(30)
        }
        
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.top.equalTo(transactionTypePicker.snp.bottom).offset(20)
            make.right.equalToSuperview().inset(SAFE_AREA_MARGIN)
            make.bottom.equalTo(addTransactionButton.snp.top).inset(20)
        }
        
        addTransactionButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(SAFE_AREA_MARGIN)
            make.bottom.equalToSuperview().offset(-80)
            make.right.equalToSuperview().offset(-SAFE_AREA_MARGIN)
            make.height.equalTo(52)
        }
        
        super.updateViewConstraints()
    }
}
