//
//  SearchViewController.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/05/22.
//  Copyright © 2019 森宥貴. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage
import TagListView
import NVActivityIndicatorView
import Reachability
import DZNEmptyDataSet

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource
{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var refreshCtl:UIRefreshControl!
    
    var activityIndicatorView: NVActivityIndicatorView!
    let reachability = Reachability()
    
    var titleArray: [String] = []
    var urlJsonArray: [String] = []
    var urlArray: [String] = []
    var dateArray: [String] = []
    var authorArray: [String] = []
    var thumbnailArray: [String] = []
    var thumbnailJsonArray: [String] = []
    var categoryArray: [[String]] = [[]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.emptyDataSetDelegate = self
        tableView.emptyDataSetSource = self

        setIndicator()
        setRefreshControl()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 163
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
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
        
        //Author
        cell.newsAuthorLabel.text = self.authorArray[indexPath.row]
        cell.newsAuthorLabel.backgroundColor = UIColor.white
        cell.newsAuthorLabel.textColor = UIColor.lightGray
        cell.newsAuthorLabel.sizeToFit()
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let indexPath = self.tableView.indexPathForSelectedRow
        {
            let homeWebViewController = segue.destination as! HomeWebViewController
            
            print("\(urlArray[indexPath.row])")
            homeWebViewController.receiveUrl = urlArray[indexPath.row]
        }
    }
    
    /*
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
    }
 */
 
    /*
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool
    {
    }
 */
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        print("SearchButton Celicked.")
        
        activityIndicatorView.startAnimating()
        tableView.isHidden = true
        searchBar.resignFirstResponder()
        
        if searchBar.text == ""
        {
            print("searchBar.text is empty.")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5)
            {
                self.titleArray.removeAll()
                self.urlJsonArray.removeAll()
                self.urlArray.removeAll()
                self.thumbnailArray.removeAll()
                self.thumbnailJsonArray.removeAll()
                self.authorArray.removeAll()
                self.categoryArray.removeAll()
                self.dateArray.removeAll()
                
                self.tableView.reloadData()
                
                self.tableView.isHidden = false
                
                self.activityIndicatorView.stopAnimating()
            }
        }
        else
        {
            print("searchBar.text is not empty ")
            self.request()
        }
    }
    
    @IBAction func backButton(_ sender: Any)
    {
        presentingViewController?.dismiss(animated: false, completion: nil)
    }
    
    func request()
    {
        let requestUrl = "https://petea.jp/searchjson/?keyword=\(searchBar.text!)"
        let url = requestUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        Alamofire.request(url,
                          method: .get,
                          parameters: nil,
                          encoding: JSONEncoding.default,
                          headers: nil)
            .validate()
            .responseJSON
            {response in
                
                if response.result.isSuccess == true
                {
                    print("passed")
                    print("\(requestUrl)")
                    
                    self.titleArray.removeAll()
                    self.urlJsonArray.removeAll()
                    self.urlArray.removeAll()
                    self.thumbnailArray.removeAll()
                    self.thumbnailJsonArray.removeAll()
                    self.authorArray.removeAll()
                    self.categoryArray.removeAll()
                    self.dateArray.removeAll()
                    
                    guard let data = response.data else
                    {
                        return
                    }
                    
                    let elements = try? JSONDecoder().decode([SearchElements].self, from: data)
                    
                    if elements != nil
                    {
                        for element in elements!
                        {
                            //Print element.
                            print("---------------------------------------------")
                            print("TITLE      | \(element.title)")
                            print("URL      | \(element.permalink)")
                            
                            self.titleArray.append(element.title)
                            self.urlJsonArray.append(element.permalink)
                            self.thumbnailJsonArray.append(element.thumbnail)
                            self.categoryArray.append(element.categories)
                            self.dateArray.append(element.date)
                            self.authorArray.append(element.author)
                            
                            self.thumbnailArray = self.thumbnailJsonArray.map { "https://petea.jp" + $0 }
                            self.urlArray = self.urlJsonArray.map{ "https://petea.jp" + $0 }
                        }
                    }
                    else
                    {
                        print("elementsはnilだよ")
                    }
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                    self.activityIndicatorView.stopAnimating()
                }
                    
                else if response.result.isFailure == true
                {
                    print("failed")
                    print("\(requestUrl)")
                }
                else
                {
                    print("else")
                }
        }
    }
    
    func setIndicator()
    {
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 , width: 60, height: 60), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.lightGray, padding: 0)
        
        view.addSubview(activityIndicatorView)
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = "検索結果が見つかりません\n"
        let font = UIFont.systemFont(ofSize: 22)
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString!
    {
        let text = "別のキーワードでお試しください\n"
        let font = UIFont.systemFont(ofSize: 16)
        return NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage!
    {
        return UIImage(named: "OOPS")
    }
    
    func confirmNetworkConnection()
    {
        reachability?.whenReachable = { reachability in
            print("Network Connected.")
            self.activityIndicatorView.startAnimating()
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
        try? reachability?.startNotifier()
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
}
    


