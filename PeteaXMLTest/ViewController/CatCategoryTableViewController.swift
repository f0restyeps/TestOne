//
//  CatCategoryTableViewController.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/04/25.
//  Copyright © 2019 森宥貴. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import TagListView
import NVActivityIndicatorView
import Reachability
import DZNEmptyDataSet

class CatCategoryTableViewController: UITableViewController,TagListViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate
{
    var refreshCtl:UIRefreshControl!
    
    var activityIndicatorView: NVActivityIndicatorView!
    var indicatorView: NVActivityIndicatorView!
    
    let reachability = Reachability()
    
    var titleArray: [String] = [""]
    var urlJsonArray: [String] = [""]
    var urlArray: [String] = [""]
    var dateArray: [String] = [""]
    var authorArray: [String] = [""]
    var thumbnailArray: [String] = [""]
    var thumbnailJsonArray: [String] = [""]
    var categoryArray: [[String]] = [[""]]
    var tagArray: [[String]] = [[""]]
    
    override func viewWillAppear(_ animated: Bool)
    {
        UserDefaults.standard.removeObject(forKey: "INDEX_PATH")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self
        
        tableView.separatorStyle = .none
        tableView.reloadData()
        confirmNetworkConnection()
    }
    
    override func viewDidLoad()
    {
        setIndicator()
        activityIndicatorView.startAnimating()
        
        DispatchQueue.main.async
            {
                self.setRefreshControl()
        }
    }
    
    func setIndicator()
    {
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 60 - 50 , width: 60, height: 60), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.lightGray, padding: 0)
        view.addSubview(activityIndicatorView)
    }
    
    func setRefreshControl()
    {
        refreshCtl = UIRefreshControl()
        refreshCtl.tintColor = UIColor.lightGray
        refreshCtl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshCtl)
    }
    
    @objc func refresh()
    {
        perform(#selector(delay), with: nil, afterDelay: 2.0)
    }
    
    @objc func delay()
    {
        tableView.reloadData()
        refreshCtl.endRefreshing()
    }
    
    //Setting TableView.
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch indexPath.row
        {
        case 0:
            
            return 52
            
        default:
            
            return 163
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titleArray.count
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = "読み込みに失敗しました\n"
        let font = UIFont.systemFont(ofSize: 22)
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = "通信状況を確認して下さい\n"
        let font = UIFont.systemFont(ofSize: 16)
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "OOPS")
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        switch indexPath.row
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "catLabelCell", for: indexPath)
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsListTableViewCell
            
            cell.tagListView.removeAllTags()
            
            //Thumbnail
            let thumbnailImage = thumbnailArray[indexPath.row]
            cell.newsImageView.sd_setImage(with: URL(string: thumbnailImage), placeholderImage: UIImage(named: ""))
            cell.newsImageView.clipsToBounds = true
            cell.newsImageView.layer.cornerRadius = 0
            cell.newsImageView.contentMode = UIView.ContentMode.scaleToFill
            
            //Title
            cell.newsTitleLabel.text = self.titleArray[indexPath.row]
            cell.newsTitleLabel.backgroundColor = UIColor.white
            cell.newsTitleLabel.textColor = UIColor.darkGray
            //cell.newsTitleLabel.sizeToFit()
            
            //Author
            cell.newsAuthorLabel.text = self.authorArray[indexPath.row]
            cell.newsAuthorLabel.backgroundColor = UIColor.white
            cell.newsAuthorLabel.textColor = UIColor.lightGray
            cell.newsAuthorLabel.sizeToFit()
            
            //Tags
            let category = categoryArray[indexPath.row]
            cell.tagListView.addTags(category)
            
            //Date
            var date:String = String()
            let dateFormatterGet = DateFormatter()
            let dateFormatterPrint = DateFormatter()
            
            dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatterPrint.dateFormat = "yyyy年MM月dd日"
            
            date = self.dateArray[indexPath.row]
            if let formatDate = dateFormatterGet.date(from: date)
            {
                cell.newsDateLabel.text = dateFormatterPrint.string(from: formatDate)
                cell.newsDateLabel.backgroundColor = UIColor.white
                cell.newsDateLabel.textColor = UIColor.lightGray
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            let homeWebViewController = segue.destination as! HomeWebViewController
            
            print("\(urlArray[indexPath.row])")
            homeWebViewController.receiveUrl = urlArray[indexPath.row]
        }
    }
    
    func confirmNetworkConnection()
    {
        reachability?.whenReachable = { reachability in
            print("Network Connected.")
            DispatchQueue.global().async
                {
                    self.tableView.separatorStyle = .none
                    self.request()
            }
        }
        
        reachability?.whenUnreachable = { reachability in
            print("Network Disconnected")
            self.activityIndicatorView.stopAnimating()
            self.titleArray.removeAll()
            self.tableView.separatorStyle = .none
            self.tableView.reloadData()
        }
        //category/dog/json
        try? reachability?.startNotifier()
    }
    
    func request()
    {
        self.activityIndicatorView.startAnimating()
        
        let requestUrl = "https://petea.jp/category/cat/json"
        
        Alamofire.request(requestUrl,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil)
            .response
            {
                response in
                guard let data = response.data else
                {
                    return
                }
                let elements = try! JSONDecoder().decode([Elements].self, from: data)
                
                for element in elements
                {
                    //Print element.
                    print("--------------------------------------------------------------------------")
                    print("TITLE      | \(element.title)")
                    print("URL        | \(element.permalink)")
                    print("DATE       | \(element.date)")
                    print("AUTHOR     | \(element.author)")
                    print("THUMBNAIL  | \(element.thumbnail)")
                    print("CATEGORIES | \(element.categories)")
                    print("TAGS       | \(element.tags)")
                    
                    self.titleArray.append(element.title)
                    self.urlJsonArray.append(element.permalink)
                    self.dateArray.append(element.date)
                    self.authorArray.append(element.author)
                    self.thumbnailJsonArray.append(element.thumbnail)
                    self.categoryArray.append(element.categories)
                    self.tagArray.append(element.tags)
                    
                    self.thumbnailArray = self.thumbnailJsonArray.map { "https://petea.jp" + $0 }
                    self.urlArray = self.urlJsonArray.map{ "https://petea.jp" + $0 }
                    
                    DispatchQueue.main.async
                        {
                            self.tableView.isHidden = false
                            self.tableView.separatorStyle = .singleLine
                            self.tableView.reloadData()
                            self.activityIndicatorView.stopAnimating()
                    }
                }
        }
    }
}
