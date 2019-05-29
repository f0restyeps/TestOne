//
//  HomeWebViewController.swift
//  PeteaXMLTest
//
//  Created by 森宥貴 on 2019/05/08.
//  Copyright © 2019 森宥貴. All rights reserved.
//

import UIKit
import WebKit
import NVActivityIndicatorView

class HomeWebViewController: UIViewController,WKUIDelegate,UIWebViewDelegate,WKNavigationDelegate
{
    @IBOutlet weak var wkWebView: WKWebView!
    
    var receiveUrl: String = String()
    var activityIndicatorView: NVActivityIndicatorView!

    override func viewWillAppear(_ animated: Bool)
    {
        setIndicator()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        wkWebView.uiDelegate = self
        wkWebView.navigationDelegate = self
        
        let urlRequest = URLRequest(url:URL(string:receiveUrl)!)
        wkWebView.load(urlRequest)
    }
    
    //通信の開始
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)
    {
        print("通信開始")
        activityIndicatorView.startAnimating()
    }
 
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)
    {
        print("通信終了")
        activityIndicatorView.stopAnimating()
    }
 
    func setIndicator()
    {
        activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: self.view.frame.width / 2 - 30, y: self.view.frame.height / 2 - 60 - 50 , width: 60, height: 60), type: NVActivityIndicatorType.circleStrokeSpin, color: UIColor.lightGray, padding: 0)
        
        view.addSubview(activityIndicatorView)
    }

}
