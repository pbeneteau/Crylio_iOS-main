//
//  ChartLegendView.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 20/05/2021.
//

import UIKit


internal enum ChartLegendDirection {
    
    case horizontal
    case vertical
}


class ChartLegendView: UIView {
    
    var direction: ChartLegendDirection = .vertical
    
    var xOffset = 10
    var yOffset = 10
    
    lazy var tableView = UITableView()
    
    var values: [PieChartValue]! {
        didSet {
            updateData()
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

    private func commonInit() {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .clear
        tableView.backgroundColor = .clear
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(ChartLegendTableViewCell.self, forCellReuseIdentifier: ChartLegendTableViewCell.reuseId)
     
        tableView.isScrollEnabled = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorStyle = .none

        addSubview(tableView)
    }
    
    func updateData() {

        tableView.reloadData()
    }
}


// MARKS: Table View delegate and datasource

extension ChartLegendView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return values.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChartLegendTableViewCell.reuseId, for: indexPath) as? ChartLegendTableViewCell else {
            fatalError("The dequeued cell is not an instance of ChartLegendTableViewCell.")
        }
        
        cell.value = values[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.height / CGFloat(values.count)
    }
    
}


// MARKS: Constraints

extension ChartLegendView {
   
   override func updateConstraints() {
       
       tableView.snp.makeConstraints { make in
           make.center.equalToSuperview()
           make.height.width.equalToSuperview()
       }
       
       super.updateConstraints()

   }
}
