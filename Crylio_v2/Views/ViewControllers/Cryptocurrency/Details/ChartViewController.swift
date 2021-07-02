//
//  ChartViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 11/05/2021.
//

import UIKit


protocol ChartViewControllerDelegate: NSObjectProtocol {
    
    func dateRangeDidChange(dateRange: TradingviewChartDateRange)
}

class ChartViewController: UIViewController {
    
    lazy var tradingviewChartView = TradingviewChartView()
    lazy var dateRangeSelectorCV = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    weak var delegate: ChartViewControllerDelegate!

    var tradingviewChart: TradingviewChart!
    private let ranges = TradingviewChartDateRange.allCases

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.background.primary
        
        tradingviewChartView.tradingviewChart = tradingviewChart
                
        if let layout = dateRangeSelectorCV.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        dateRangeSelectorCV.register(DateRangeSelectorCollectionViewCell.self, forCellWithReuseIdentifier: DateRangeSelectorCollectionViewCell.reuseId)
        dateRangeSelectorCV.showsHorizontalScrollIndicator = false
        dateRangeSelectorCV.contentInset = UIEdgeInsets(top: 0, left: CONTENT_HORIZONTAL_MARGIN, bottom: 0, right: 0)
        dateRangeSelectorCV.delegate = self
        dateRangeSelectorCV.dataSource = self
        dateRangeSelectorCV.backgroundColor = .clear
        
        dateRangeSelectorCV.reloadData()
        dateRangeSelectorCV.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        
        view.addSubview(tradingviewChartView)
        view.addSubview(dateRangeSelectorCV)
    }
    
}

// MARK: - Collection view delegate and datasource

extension ChartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ranges.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = dateRangeSelectorCV.dequeueReusableCell(withReuseIdentifier: DateRangeSelectorCollectionViewCell.reuseId, for: indexPath) as? DateRangeSelectorCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of DateRangeSelectorCollectionViewCell.")
        }
        
        cell.dateRangeLabel.text = ranges[indexPath.row].description
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected date range: " + ranges[indexPath.row].description)

        tradingviewChartView.tradingviewChart.dateRange = ranges[indexPath.row]
        tradingviewChartView.reloadChart()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (ranges[indexPath.row].description as NSString).size(withAttributes: nil).width + 26
        return CGSize(width: width, height: 30)
    }
    
}


// MARK: - Constraints

extension ChartViewController {
    
    override func updateViewConstraints() {
        
        tradingviewChartView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview().offset(50)
            make.bottom.equalToSuperview().inset(90)
            make.width.equalToSuperview()
        }
        
        dateRangeSelectorCV.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(tradingviewChartView.snp.bottom).offset(5)
            make.height.equalTo(35)
        }

        super.updateViewConstraints()
    }
}


// MARK: - Interface style handling for chart

extension ChartViewController {
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        
        tradingviewChartView.reloadChart()
    }
        
}
