//
//  PortfolioDetailViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 21/06/2021.
//

import UIKit

class PortfolioDetailViewController: UIViewController {
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsHorizontalScrollIndicator = false
        view.backgroundColor = .clear
        return view
    }()
    
    lazy var balanceView = PortfolioBalanceView()
    lazy var majorHoldingsView = AssetAllocationView()
    lazy var dailyPNLView = DailyPNLView()
    
    var majorAssetsHoldings = [String: AssetAllocationItem]()
    
    private var isBalancesHidden = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = AppColors.background.primary
      
        let hideIcon = UIImage(named: "hide")?.withRenderingMode(.alwaysTemplate)
        let settingsIcon = UIImage(named: "settings")?.withRenderingMode(.alwaysTemplate)
        
        let hideNavigationItem = UIBarButtonItem(image: hideIcon, style: .plain, target: self, action: #selector(didTapHideBalanceButton(_:)))
        let settingsNavigationItem = UIBarButtonItem(image: settingsIcon, style: .plain, target: self, action: #selector(didTapSettingsButton(_:)))
        
        hideNavigationItem.tintColor = AppColors.label.primary
        settingsNavigationItem.tintColor = AppColors.label.primary
        
        navigationItem.rightBarButtonItems = [settingsNavigationItem, hideNavigationItem]
        
        majorAssetsHoldings = ["firstAsset": AssetAllocationItem(name: crypto1.name, symbol: crypto1.symbol, iconURL: crypto1.iconURL, value: 30, accentColor: .systemOrange), "secondAsset": AssetAllocationItem(name: crypto2.name, symbol: crypto2.symbol, iconURL: crypto2.iconURL, value: 10, accentColor: .systemGreen), "thirdAsset": AssetAllocationItem(name: crypto1.name, symbol: crypto1.symbol, iconURL: crypto1.iconURL, value: 10, accentColor: .systemBlue), "other": AssetAllocationItem(name: "", symbol: "Other", iconURL: crypto2.iconURL, value: 90, accentColor: AppColors.background.tertiary)]
                        
        view.addSubview(scrollView)
        scrollView.addSubview(balanceView)
        scrollView.addSubview(majorHoldingsView)
        scrollView.addSubview(dailyPNLView)
        
        view.setNeedsUpdateConstraints()
        
        updateValues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        resizeScrollViewContent()
    }
    
    private func updateValues() {
        
        majorHoldingsView.items = majorAssetsHoldings
    }
    
    func resizeScrollViewContent() {
                
        scrollView.contentSize.height = scrollView.contentInset.top + dailyPNLView.frame.maxY
    }
    
    // MARK: - Constraints
    
    override func updateViewConstraints() {
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
                
        balanceView.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.width.equalToSuperview().offset(-SAFE_AREA_MARGIN*2)
            make.top.equalToSuperview()
        }
        
        majorHoldingsView.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.width.equalToSuperview().offset(-SAFE_AREA_MARGIN*2)
            make.top.equalTo(balanceView.snp.bottom).offset(30)
            make.height.equalTo(250)
        }
        
        dailyPNLView.snp.makeConstraints { make in
            make.left.equalTo(SAFE_AREA_MARGIN)
            make.width.equalToSuperview().offset(-SAFE_AREA_MARGIN*2)
            make.top.equalTo(majorHoldingsView.snp.bottom).offset(30)
        }
        
        super.updateViewConstraints()
    }

}


// MARK: - Buttons delegate

extension PortfolioDetailViewController {
    
    @objc func didTapSettingsButton(_ sender: UIBarButtonItem) {
        
        print("portfolio settings...")
                
        let popoverVC = UIViewController()
        popoverVC.title = "Portfolio Settings"
        popoverVC.view.backgroundColor = AppColors.background.primary
        popoverVC.popoverPresentationController?.sourceView = self.view
        popoverVC.popoverPresentationController?.permittedArrowDirections = .up
        
        let navVC = UINavigationController(rootViewController: popoverVC)
    
        navigationController?.present(navVC, animated: true, completion: nil)
    }
    
    @objc func didTapHideBalanceButton(_ sender: UIBarButtonItem) {
        
        if isBalancesHidden {
            setBalancesHiddenState(false)
        } else {
            setBalancesHiddenState(true)
        }
        isBalancesHidden = !isBalancesHidden
    }
    
    private func setBalancesHiddenState(_ hidden: Bool) {
        
        if hidden {
            balanceView.balanceView.valueLabel.text = "******"
            balanceView.yesterdayPNLValueLabel.text = "******"
            balanceView.monthPNLValueLabel.text = "******"
            balanceView.balanceView.valueLabel.textColor = AppColors.label.secondary
            balanceView.yesterdayPNLValueLabel.textColor = AppColors.label.secondary
            balanceView.monthPNLValueLabel.textColor = AppColors.label.secondary
        } else {
            balanceView.balanceView.valueLabel.textColor = AppColors.label.primary
            balanceView.updateValues()
        }
    }
}

struct AssetAllocationItem {
    
    var name: String
    var symbol: String
    var iconURL: String
    var value: Float
    var accentColor: UIColor
}

class AssetAllocationView: BackgroundBoxWithTitleView {
    
    lazy var legendTableView = UITableView()
    lazy var bubblesView = AssetAllocationBubblesView()

    var items: [String: AssetAllocationItem]! {
        didSet {
            updateValues()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }

    override func commonInit() {
        super.commonInit()
        
        titleLabel.text = "Major Holdings"
        
        legendTableView.delegate = self
        legendTableView.dataSource = self
        
        legendTableView.register(MajorHoldingsLegendTableViewCell.self, forCellReuseIdentifier: MajorHoldingsLegendTableViewCell.reuseId)
        legendTableView.backgroundColor = .clear
        legendTableView.isScrollEnabled = false
        legendTableView.contentInsetAdjustmentBehavior = .never
        legendTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        legendTableView.separatorStyle = .none
        legendTableView.rowHeight = 45
        
        addSubview(legendTableView)
        addSubview(bubblesView)
        
        setNeedsUpdateConstraints()
    }
    
    private func updateValues() {
                
        legendTableView.reloadData()
        bubblesView.items = items
    }
    
    // MARK: - Constraints
    
    override func makeConstraints() {
        super.makeConstraints()

        legendTableView.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.width.equalTo(140)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-CONTENT_BOTTOM_MARGIN)
        }

        bubblesView.snp.makeConstraints { make in
            make.left.equalTo(legendTableView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.bottom.equalToSuperview().offset(-CONTENT_BOTTOM_MARGIN)
        }
    }
    
}


// MARK: - Table view delegate and datasource

extension AssetAllocationView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MajorHoldingsLegendTableViewCell.reuseId, for: indexPath) as? MajorHoldingsLegendTableViewCell else {
            fatalError("The dequeued cell is not an instance of MajorHoldingsLegendTableViewCell.")
        }
        
        switch indexPath.row {
        case 0:
            cell.item = items["firstAsset"]
        case 1:
            cell.item = items["secondAsset"]
        case 2:
            cell.item = items["thirdAsset"]
        default:
            cell.item = items["other"]
        }
                
        return cell
    }
    
}


class PortfolioBalanceView: BackgroundBoxView {
    
    lazy var balanceView = BalanceView()
    
    lazy var yesterdayPNLTilteLabel = UILabel()
    lazy var yesterdayPNLValueLabel = UILabel()
    
    lazy var monthPNLTilteLabel = UILabel()
    lazy var monthPNLValueLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    override func commonInit() {
        super.commonInit()
                
        yesterdayPNLTilteLabel.text = "Yesterday Loss"
        monthPNLTilteLabel.text = "30 days Loss"
        
        yesterdayPNLTilteLabel.font = .systemFont(ofSize: 13, weight: .medium)
        monthPNLTilteLabel.font = .systemFont(ofSize: 13, weight: .medium)
        
        yesterdayPNLTilteLabel.textColor = AppColors.label.secondary
        monthPNLTilteLabel.textColor = AppColors.label.secondary
        
        yesterdayPNLValueLabel.font = .systemFont(ofSize: 17, weight: .medium)
        monthPNLValueLabel.font = .systemFont(ofSize: 17, weight: .medium)
        
        balanceView.titleLabel.text = "Total Value"

        addSubview(balanceView)
        addSubview(yesterdayPNLTilteLabel)
        addSubview(yesterdayPNLValueLabel)
        addSubview(monthPNLTilteLabel)
        addSubview(monthPNLValueLabel)
        
        setNeedsUpdateConstraints()
        
        updateValues()
    }
    
    func updateValues() {
        
        balanceView.valueLabel.text = Float(140509.85).toDollarString()
        balanceView.progressBar.progress = 79.5/100
        balanceView.percent.text = Float(79.5).toPercentString()
                
        let yesterdayPNLValueText = "\(Float(-1.51).toPercentString()) (\(Float(-4355.63).toDollarString()))"
        yesterdayPNLValueLabel.textColor = -1.51 <= 0 ? AppColors.accent.red: AppColors.accent.green
        yesterdayPNLValueLabel.text = yesterdayPNLValueText
        
        let monthPNLValueText = "\(Float(-14.86).toPercentString()) (\(Float(-23297.52).toDollarString()))"
        monthPNLValueLabel.textColor = -14.86 <= 0 ? AppColors.accent.red: AppColors.accent.green
        monthPNLValueLabel.text = monthPNLValueText
    }
    
    // MARK: - Constraints
    
    override func makeConstraints() {
        super.makeConstraints()
        
        balanceView.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(120)
        }

        yesterdayPNLTilteLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().offset(-CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(balanceView.snp.bottom).offset(10)
            make.height.equalTo(16)
        }

        yesterdayPNLValueLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().offset(-CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(yesterdayPNLTilteLabel.snp.bottom).offset(7)
            make.height.equalTo(20)
        }

        monthPNLTilteLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().offset(-CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(yesterdayPNLValueLabel.snp.bottom).offset(15)
            make.height.equalTo(16)
        }

        monthPNLValueLabel.snp.makeConstraints { make in
            make.left.equalTo(CONTENT_HORIZONTAL_MARGIN)
            make.right.equalToSuperview().offset(-CONTENT_HORIZONTAL_MARGIN)
            make.top.equalTo(monthPNLTilteLabel.snp.bottom).offset(7)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().offset(-CONTENT_BOTTOM_MARGIN)
        }
    }
}

