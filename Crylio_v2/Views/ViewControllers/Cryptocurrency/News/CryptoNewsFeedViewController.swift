//
//  CryptoFeedViewController.swift
//  Crylio_v2
//
//  Created by Paul Bénéteau on 08/02/2021.
//

import UIKit
import Kingfisher


struct News {
    
    var type: NewsType
    var title: String
    var autor: String
    var imageURL: String?
    var url: String
    var time: Date
}

enum NewsType: String {
    
    case web = "web"
    case twitter = "twitter"
}


class CryptoNewsFeedViewController: BaseViewController {
    
    lazy var tableView = UITableView(frame: CGRect.zero, style: .plain)
    
    var refreshControl = UIRefreshControl()
    
    weak var scrollViewDelegate: ScrollViewDidScrollDelegate?
    
    var blurredHeaderViewAlpha: CGFloat = 0.0
    
    var news = [News]() {
        didSet {
            initValues()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.isHidden = true
        
        commonInit()
        
        news.append(News(type: .twitter, title: "When the #Bitcoin price deflates @TomBrady knows how to stack more sats for less $$. Thumbs up", autor: "@Bitcoin", imageURL: nil, url: "https://twitter.com/Bitcoin/status/1395220937281130498?s=20", time: Date()))
        
        news.append(News(type: .web, title: "Will Cryptocurrencies and Blockchain Replace Banking and Finance?", autor: "Crypto Basics", imageURL: "https://assets-global.website-files.com/5f3306add5c511ca4cf17da9/60a7b762626b45254475b9db_Will%20Cryptocurrencies%20And%20Blockchain%20Replace%20Banking%20And%20Finance.jpg", url: "https://coinmarketcap.com/alexandria/article/will-cryptocurrencies-and-blockchain-replace-banking-and-finance", time: Date()))
        
        
        tableView.reloadData()
    }
    
    private func commonInit() {
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.register(CryptoNewsCell.self, forCellReuseIdentifier: CryptoNewsCell.reuseId)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layoutMargins.top = 0
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView() // remove extra separators below UITableView
        tableView.addSubview(refreshControl)

        view.addSubview(tableView)
    }
    
    func updateInsets(menuMaxY: CGFloat) {
        
        tableView.contentInset = UIEdgeInsets(top: menuMaxY, left: 0, bottom: view.frame.height, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: menuMaxY, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.contentInset.top)
    }
    
    @objc private func refresh() {
        
        print("Refreshing data...")
        
        let seconds = 4.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            self.refreshControl.endRefreshing()
        }
    }
    
    private func initValues() {
        
        tableView.reloadData()
    }
    
    
    @objc private func shareNewsButton(_ sender: UIButton) {
        
        let newsUrl = news[sender.tag].url
        
        // Setting description
        let firstActivityItem = news[sender.tag].title
        
        // Setting url
        let secondActivityItem : NSURL = NSURL(string: newsUrl)!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem, secondActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [
            UIActivity.ActivityType.message
        ] as? UIActivityItemsConfigurationReading
        
        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFacebook
        ]
        
        activityViewController.isModalInPresentation = true
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
}


// MARKS: Table view delegate and datasource

extension CryptoNewsFeedViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CryptoNewsCell.reuseId, for: indexPath) as? CryptoNewsCell  else {
            fatalError("The dequeued cell is not an instance of HomeTableViewCell.")
        }
        
        cell.moreButton.addTarget(self, action: #selector(shareNewsButton(_:)), for: .touchUpInside)
        cell.moreButton.tag = indexPath.row
        
        cell.news = news[indexPath.row]
        cell.newsImageView.kf.cancelDownloadTask()
        
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped news at index: \(indexPath.row).")
    }
}


// MARKS: Scroll view delegate

extension CryptoNewsFeedViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard let delegate = scrollViewDelegate else { return }
        delegate.scrollViewDidScrollVertically(scrollView: scrollView)
    }
    
}


// MARKS: Constraints

extension CryptoNewsFeedViewController {
    
    override func updateViewConstraints() {
        
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        super.updateViewConstraints()
    }
    
}

